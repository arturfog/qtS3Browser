/*
# Copyright (C) 2018  Artur Fogiel
# This file is part of qtS3Browser.
#
# qtS3Browser is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# qtS3Browser is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with qtS3Browser.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "inc/s3client.h"
#include "inc/logmgr.h"

#include <aws/core/auth/AWSCredentialsProvider.h>
// Utils
#include <aws/core/utils/ratelimiter/DefaultRateLimiter.h>
// Objects
#include <aws/s3/model/Object.h>
#include <aws/s3/model/GetObjectRequest.h>
#include <aws/s3/model/DeleteObjectRequest.h>
#include <aws/s3/model/DeleteObjectsRequest.h>
#include <aws/s3/model/PutObjectRequest.h>
#include <aws/s3/model/ListObjectsRequest.h>
// Buckets
#include <aws/s3/model/Bucket.h>
#include <aws/s3/model/CreateBucketRequest.h>


#include <iostream>
#include <fstream>
#include <regex>
#include <QSettings>
#include <QDir>
#include <memory>

std::function<void(const std::string&)> S3Client::m_stringFunc;
std::function<void(const std::string&)> S3Client::m_errorFunc;
std::function<void()> S3Client::m_refreshFunc;
std::function<void(const unsigned long bytes, const unsigned long total, const std::string key)> S3Client::m_progressFunc;

std::shared_ptr<Aws::Utils::Threading::PooledThreadExecutor> S3Client::executor =
        Aws::MakeShared<Aws::Utils::Threading::PooledThreadExecutor>("s3-executor", 10);
std::map<Aws::String, S3Client::ObjectInfo_S> S3Client::objectInfoVec;
Aws::String S3Client::currentPrefix;
std::vector<std::string> S3Client::items;
Aws::Transfer::TransferManagerConfiguration S3Client::transferConfig(S3Client::executor.get());
std::shared_ptr<Aws::Transfer::TransferManager> S3Client::transferManager;
std::shared_ptr<Aws::S3::S3Client> S3Client::m_s3client;
// --------------------------------------------------------------------------
void S3Client::init() {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        config = new Aws::Client::ClientConfiguration();
        retryStrategy = std::shared_ptr<Aws::Client::DefaultRetryStrategy>(new Aws::Client::DefaultRetryStrategy(5));
        config->retryStrategy = retryStrategy;

        loadConfig();

#ifdef QT_DEBUG
/*
        config.scheme = Aws::Http::Scheme::HTTP;
        auto m_limiter = Aws::MakeShared<Aws::Utils::RateLimits::DefaultRateLimiter<>>(ALLOCATION_TAG.c_str(), 3929000);
        //auto m_limiter = Aws::MakeShared<Aws::Utils::RateLimits::DefaultRateLimiter<>>(ALLOCATION_TAG.c_str(), 29000);
        config.readRateLimiter = m_limiter;
        config.writeRateLimiter = m_limiter;
*/
#endif
        std::shared_ptr<Aws::S3::S3Client> s3_client(new Aws::S3::S3Client(credentials, *config));
        m_s3client = s3_client;

        //
        transferConfig.s3Client = s3_client;
        transferConfig.transferInitiatedCallback = &transferInitiatedHandler;
        transferConfig.transferStatusUpdatedCallback = &statusUpdate;
        transferConfig.uploadProgressCallback = &uploadProgress;
        transferConfig.downloadProgressCallback = &downloadProgress;
        transferConfig.errorCallback = &errorHandler;
    }
    Aws::ShutdownAPI(options);
}
// --------------------------------------------------------------------------
void S3Client::loadConfig()
{
    LogMgr::debug(Q_FUNC_INFO);
    try 
    {
        QSettings settings;
        if(settings.contains("AccessKey") && settings.contains("SecretKey")) {
            const QString sk = settings.value("SecretKey").toString();
            const QString ak = settings.value("AccessKey").toString();

            if(!sk.isEmpty() && !ak.isEmpty()) {
                credentials.SetAWSSecretKey(sk.toStdString().c_str());
                credentials.SetAWSAccessKeyId(ak.toStdString().c_str());
            }
        }

        if(settings.contains("Region")) {
            const QString reg = settings.value("Region").toString();
            if(!reg.isEmpty()) {
                config->region = reg.toStdString().c_str();
            }
        }

        if(settings.contains("Endpoint")) {
            const QString end = settings.value("Endpoint").toString();
            if(!end.isEmpty()) {
                config->endpointOverride = end.toStdString().c_str();
            }
        }

        if(settings.contains("Timeout")) {
            const int timeout = settings.value("Timeout").toInt();
            if(timeout > 0) {
                config->requestTimeoutMs = (timeout * 1000);
            }
        }
    } catch(...) {
        const std::exception_ptr exp = std::current_exception();
        m_errorFunc((exp ? exp.__cxa_exception_type()->name() : "null"));
    }
}
// --------------------------------------------------------------------------
void S3Client::reloadCredentials()
{
    loadConfig();

    m_s3client = std::make_shared<Aws::S3::S3Client>(Aws::S3::S3Client(credentials, *config));
    transferConfig.s3Client = m_s3client;
}
// --------------------------------------------------------------------------
void S3Client::listObjects(const Aws::String &bucket_name,
                           const Aws::String &key,
                           const Aws::String &marker,
                           std::function<void(const std::string&)> func) {

    LogMgr::debug(Q_FUNC_INFO);

    if(!bucket_name.empty()) {
        Aws::S3::Model::ListObjectsRequest objects_request;
        objects_request.SetBucket(bucket_name);
        objects_request.SetDelimiter("/");

        if(!key.empty()) {
            objects_request.SetPrefix(key);
        }

        if(!marker.empty()) {
            objects_request.SetMarker(marker);
        } else {
            objectInfoVec.clear();
        }

        m_stringFunc = func;
        m_s3client->ListObjectsAsync(objects_request, &listObjectsHandler);
    }
}
// --------------------------------------------------------------------------
void S3Client::listObjectsHandler(const Aws::S3::S3Client *,
                                  const Aws::S3::Model::ListObjectsRequest &request,
                                  const Aws::S3::Model::ListObjectsOutcome &outcome,
                                  const std::shared_ptr<const Aws::Client::AsyncCallerContext> &)
{
    LogMgr::debug(Q_FUNC_INFO);
    try
    {
        if (outcome.IsSuccess())
        {
            Aws::Vector<Aws::S3::Model::Object> object_list = outcome.GetResult().GetContents();

            const auto common_list = outcome.GetResult().GetCommonPrefixes();
            const auto key(request.GetPrefix());
            for (auto const &s3_object : common_list)
            {
                std::string item = regex_replace(s3_object.GetPrefix().c_str(), std::regex(key), "");
                m_stringFunc(item);
            }

            ObjectInfo_S objectInfo;
            for (auto const &s3_object : object_list)
            {
                objectInfo.size = s3_object.GetSize();
                objectInfo.lastModified = s3_object.GetLastModified();
                objectInfo.etag = s3_object.GetETag();
                objectInfo.owner = s3_object.GetOwner().GetDisplayName();

                const auto key(s3_object.GetKey());
                const std::string item = regex_replace(key.c_str(), std::regex(currentPrefix), "");
                objectInfoVec.emplace(std::make_pair(item.c_str(), objectInfo));

                m_stringFunc(s3_object.GetKey().c_str());
            }

            if(outcome.GetResult().GetIsTruncated()) {
                const auto nextMarker = object_list.back();
                if(!nextMarker.GetKey().empty()) {
                    listObjects(request.GetBucket(),
                            request.GetPrefix(),
                            nextMarker.GetKey(),
                            m_stringFunc);
                }
            }
        }
        else
        {
            m_errorFunc(outcome.GetError().GetMessage().c_str());
        }
    } catch(...) {
        const std::exception_ptr exp = std::current_exception();
        m_errorFunc((exp ? exp.__cxa_exception_type()->name() : "null"));
    }
}
// --------------------------------------------------------------------------
void S3Client::getObjectInfo(const Aws::String &bucket_name,
                             const Aws::String &key_name)
{
    LogMgr::debug(Q_FUNC_INFO);
    Aws::S3::Model::GetObjectRequest object_request;
    object_request.WithBucket(bucket_name).WithKey(key_name);
    m_s3client->GetObjectAsync(object_request, &getObjectInfoHandler);
}
// --------------------------------------------------------------------------
std::string S3Client::getModificationDate(const Aws::String &name)
{
    LogMgr::debug(Q_FUNC_INFO);
    auto it = objectInfoVec.find(name);
    if (it != objectInfoVec.end()) {
        auto item = objectInfoVec.at(name);
        Aws::String time = item.lastModified.ToLocalTimeString(Aws::Utils::DateFormat::ISO_8601);
        return time.c_str();
    }

    return "";
}
// --------------------------------------------------------------------------
std::string S3Client::getOwner(const Aws::String &name)
{
    LogMgr::debug(Q_FUNC_INFO);
    auto it = objectInfoVec.find(name);
    if (it != objectInfoVec.end()) {
        auto item = objectInfoVec.at(name);
        return item.owner.c_str();
    }

    return "";
}
// --------------------------------------------------------------------------
std::string S3Client::getETAG(const Aws::String &name)
{
    auto it = objectInfoVec.find(name);
    if (it != objectInfoVec.end()) {
        auto item = objectInfoVec.at(name);
        return item.etag.c_str();
    }

    return "";
}
// --------------------------------------------------------------------------
std::string S3Client::getPresignLink(const Aws::String &bucket_name,
                                     const Aws::String &key_name,
                                     const int expirationTimeSec)
{
    Aws::String url = m_s3client->GeneratePresignedUrl(bucket_name,
                                                      key_name,
                                                      Aws::Http::HttpMethod::HTTP_GET,
                                                      expirationTimeSec);
    return url.c_str();
}
// --------------------------------------------------------------------------
void S3Client::setRefreshCallback(std::function<void ()> refreshFunc)
{
    if(refreshFunc) { m_refreshFunc = refreshFunc; }
}
// --------------------------------------------------------------------------
void S3Client::setProgressCallback(std::function<void(const unsigned long long,
                                                       const unsigned long long,
                                                       const std::string&)> progressFunc)
{
    if(progressFunc) { m_progressFunc = progressFunc; }
}
// --------------------------------------------------------------------------
void S3Client::getObjectInfoHandler(const Aws::S3::S3Client *,
                                    const Aws::S3::Model::GetObjectRequest &request,
                                    const Aws::S3::Model::GetObjectOutcome &outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext> &)
{
    LogMgr::debug(Q_FUNC_INFO);
    try 
    {
        if (outcome.IsSuccess())
        {
            ObjectInfo_S objectInfo;

            objectInfo.size = outcome.GetResult().GetContentLength();
            objectInfo.type = outcome.GetResult().GetContentType();
    //        // ToLocalTimeString(Aws::Utils::DateFormat::ISO_8601) << std::endl;
            objectInfo.lastModified = outcome.GetResult().GetLastModified();
            objectInfo.etag = outcome.GetResult().GetETag();
            Aws::String key = request.GetKey();
            std::string item = regex_replace(key.c_str(), std::regex(currentPrefix), "");

            objectInfoVec.emplace(std::make_pair(item.c_str(), objectInfo));
        }
        else
        {
            m_errorFunc(outcome.GetError().GetMessage().c_str());
        }
    } catch(...) {
        const std::exception_ptr exp = std::current_exception();
        m_errorFunc((exp ? exp.__cxa_exception_type()->name() : "null"));
    }
}
// --------------------------------------------------------------------------
void S3Client::createBucket(const Aws::String &bucket_name)
{
    LogMgr::debug(Q_FUNC_INFO);
    Aws::S3::Model::CreateBucketRequest request;
    request.SetBucket(bucket_name);
    m_s3client->CreateBucketAsync(request, &createBucketHandler);
}
// --------------------------------------------------------------------------
void S3Client::createBucketHandler(const Aws::S3::S3Client *,
                                   const Aws::S3::Model::CreateBucketRequest &,
                                   const Aws::S3::Model::CreateBucketOutcome &outcome,
                                   const std::shared_ptr<const Aws::Client::AsyncCallerContext>&)
{
    LogMgr::debug(Q_FUNC_INFO);
    if (outcome.IsSuccess())
    {
        m_refreshFunc();
    }
    else
    {
        const std::exception_ptr exp = std::current_exception();
        m_errorFunc((exp ? exp.__cxa_exception_type()->name() : "null"));
    }
}
// --------------------------------------------------------------------------
void S3Client::uploadProgress(const Aws::Transfer::TransferManager*,
                              const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle)
{
    m_progressFunc(handle->GetBytesTransferred(), handle->GetBytesTotalSize(), handle->GetKey().c_str());
}
// --------------------------------------------------------------------------
void S3Client::downloadProgress(const Aws::Transfer::TransferManager* ,
                                const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle)
{    
    m_progressFunc(handle->GetBytesTransferred(), handle->GetBytesTotalSize(), handle->GetKey().c_str());
}
// --------------------------------------------------------------------------
void S3Client::statusUpdate(const Aws::Transfer::TransferManager *,
                            const std::shared_ptr<const Aws::Transfer::TransferHandle> &)
{

}
// --------------------------------------------------------------------------
void S3Client::errorHandler(const Aws::Transfer::TransferManager* ,
                            const std::shared_ptr<const Aws::Transfer::TransferHandle>&,
                            const Aws::Client::AWSError<Aws::S3::S3Errors>& error)
{
    LogMgr::error(error.GetMessage().c_str());
    m_errorFunc(error.GetMessage().c_str());
}
// --------------------------------------------------------------------------
void S3Client::transferInitiatedHandler(const Aws::Transfer::TransferManager *,
                                        const std::shared_ptr<const Aws::Transfer::TransferHandle> &)
{
}
// --------------------------------------------------------------------------
void S3Client::getBuckets(std::function<void(const std::string&)> func) {
    LogMgr::debug(Q_FUNC_INFO);

    m_stringFunc = func;
    objectInfoVec.clear();
    m_s3client->ListBucketsAsync(&getBucketsHandler);
}
// --------------------------------------------------------------------------
void S3Client::getBucketsHandler(const Aws::S3::S3Client *,
                                 const Aws::S3::Model::ListBucketsOutcome &outcome,
                                 const std::shared_ptr<const Aws::Client::AsyncCallerContext> &)
{
    LogMgr::debug(Q_FUNC_INFO);
    try 
    {
        if (outcome.IsSuccess())
        {
            Aws::Vector<Aws::S3::Model::Bucket> bucket_list = outcome.GetResult().GetBuckets();
            for (auto const &bucket : bucket_list)
            {
                m_stringFunc(bucket.GetName().c_str());
            }

            if(bucket_list.size() == 0) {
                m_stringFunc("");
            }
        }
        else
        {
            m_errorFunc(outcome.GetError().GetMessage().c_str());
        }
    } catch(...) {
        const std::exception_ptr exp = std::current_exception();
        m_errorFunc((exp ? exp.__cxa_exception_type()->name() : "null"));
    }
}
// --------------------------------------------------------------------------
void S3Client::deleteObject(const Aws::String &bucket_name,
                            const Aws::String &key_name) {

    LogMgr::debug(Q_FUNC_INFO, bucket_name.c_str());

    Aws::S3::Model::DeleteObjectRequest object_request;
    object_request.WithBucket(bucket_name).WithKey(key_name);
    m_s3client->DeleteObjectAsync(object_request, &deleteObjectHandler);

}
// --------------------------------------------------------------------------
void S3Client::deleteDirectory(const Aws::String &bucket_name,
                               const Aws::String &key_name)
{
    LogMgr::debug(Q_FUNC_INFO, bucket_name.c_str());

    Aws::S3::Model::ListObjectsRequest list_request;
    list_request.SetBucket(bucket_name);
    Aws::S3::Model::DeleteObjectsRequest delete_request;
    delete_request.SetBucket(bucket_name);
    Aws::S3::Model::Delete delObj;

    if(key_name != "") {
        list_request.SetPrefix(key_name);
    }

    auto outcome = m_s3client->ListObjects(list_request);
    if(outcome.IsSuccess()) {
        const auto object_list = outcome.GetResult().GetContents();
        for (const auto &s3_object : object_list)
        {
            Aws::S3::Model::ObjectIdentifier id;
            id.SetKey(s3_object.GetKey());
            delObj.AddObjects(id);
        }

#ifdef QT_DEBUG
        // TODO: refactor
        while(outcome.GetResult().GetIsTruncated()) {
            list_request.SetMarker(object_list.back().GetKey());
            outcome = m_s3client->ListObjects(list_request);
            if(outcome.IsSuccess()) {
                const auto object_list = outcome.GetResult().GetContents();
                for (const auto &s3_object : object_list)
                {
                    Aws::S3::Model::ObjectIdentifier id;
                    id.SetKey(s3_object.GetKey());
                    delObj.AddObjects(id);
                }
            } else {
                break;
            }
        }
#endif

        delete_request.SetDelete(delObj);
        m_s3client->DeleteObjectsAsync(delete_request, &deleteObjectsHandler);
    }
}
// --------------------------------------------------------------------------
void S3Client::deleteObjectHandler(const Aws::S3::S3Client *,
                                   const Aws::S3::Model::DeleteObjectRequest &,
                                   const Aws::S3::Model::DeleteObjectOutcome &outcome,
                                   const std::shared_ptr<const Aws::Client::AsyncCallerContext> &)
{
    LogMgr::debug(Q_FUNC_INFO);
    if (outcome.IsSuccess())
    {
        m_refreshFunc();
    }
    else
    {
        LogMgr::error(outcome.GetError().GetMessage().c_str());
        m_errorFunc(outcome.GetError().GetMessage().c_str());
    }
}
// --------------------------------------------------------------------------
void S3Client::deleteObjectsHandler(const Aws::S3::S3Client *,
                                    const Aws::S3::Model::DeleteObjectsRequest &,
                                    const Aws::S3::Model::DeleteObjectsOutcome &outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext> &)
{

    LogMgr::debug(Q_FUNC_INFO);
    if (outcome.IsSuccess())
    {
        m_refreshFunc();
    }
    else
    {
        LogMgr::error(outcome.GetError().GetMessage().c_str());
        m_errorFunc(outcome.GetError().GetMessage().c_str());
    }
}
// --------------------------------------------------------------------------
void S3Client::deleteBucket(const Aws::String &bucket_name)
{
    LogMgr::debug(Q_FUNC_INFO, bucket_name.c_str());

    Aws::S3::Model::DeleteBucketRequest request;
    request.SetBucket(bucket_name);

    m_s3client->DeleteBucketAsync(request, &deleteBucketHandler);

    // TODO: Remove all objects inside
}
// --------------------------------------------------------------------------
void S3Client::deleteBucketHandler(const Aws::S3::S3Client *,
                                   const Aws::S3::Model::DeleteBucketRequest &,
                                   const Aws::S3::Model::DeleteBucketOutcome &outcome,
                                   const std::shared_ptr<const Aws::Client::AsyncCallerContext> &)
{
    LogMgr::debug(Q_FUNC_INFO);
    if (outcome.IsSuccess())
    {
        m_refreshFunc();
    }
    else
    {
        m_errorFunc(outcome.GetError().GetMessage().c_str());
    }
}
// --------------------------------------------------------------------------
void S3Client::createFolder(const Aws::String &bucket_name,
                            const Aws::String &key_name)
{
    LogMgr::debug(Q_FUNC_INFO, bucket_name.c_str());

    Aws::S3::Model::PutObjectRequest object_request;

    object_request.SetBucket(bucket_name);
    object_request.SetKey(key_name);

    m_s3client->PutObjectAsync(object_request, &createFolderHandler);
}
// --------------------------------------------------------------------------
void S3Client::createFolderHandler(const Aws::S3::S3Client *,
                                   const Aws::S3::Model::PutObjectRequest &,
                                   const Aws::S3::Model::PutObjectOutcome &outcome,
                                   const std::shared_ptr<const Aws::Client::AsyncCallerContext> &)
{
    LogMgr::debug(Q_FUNC_INFO);
    if (outcome.IsSuccess())
    {
        m_refreshFunc();
    }
    else
    {
        m_errorFunc(outcome.GetError().GetMessage().c_str());
    }
}
// --------------------------------------------------------------------------
void S3Client::uploadFile(const Aws::String &bucket_name,
                          const Aws::String &key_name,
                          const Aws::String &file_name)
{
    LogMgr::debug(Q_FUNC_INFO);
    transferManager = Aws::Transfer::TransferManager::Create(transferConfig);
    if(transferManager != nullptr) {
        transferHandle = transferManager->UploadFile(file_name, bucket_name, key_name,
                                                 "text/plain", metadata);
    }
}
// --------------------------------------------------------------------------
void S3Client::uploadDirectory(const Aws::String &bucket_name,
                               const Aws::String &key_name,
                               const Aws::String &dir_name)
{
    LogMgr::debug(Q_FUNC_INFO);
    transferManager = Aws::Transfer::TransferManager::Create(transferConfig);
    if(transferManager != nullptr) {
        transferManager->UploadDirectory(dir_name, bucket_name, key_name, metadata);
    }
}
// --------------------------------------------------------------------------
void S3Client::cancelDownloadUpload()
{
    // TODO: manage handles
    LogMgr::debug(Q_FUNC_INFO);
    if(transferHandle != nullptr) {
        transferHandle->Cancel();
    }
}
// --------------------------------------------------------------------------
void S3Client::setErrorHandler(std::function<void(const std::string&)> errorFunc)
{
    m_errorFunc = errorFunc;
}
// --------------------------------------------------------------------------
void S3Client::downloadFile(const Aws::String &bucket_name,
                            const Aws::String &key_name,
                            const Aws::String &file_name)
{
    LogMgr::debug(Q_FUNC_INFO, file_name.c_str());
    transferManager = Aws::Transfer::TransferManager::Create(transferConfig);
    if(transferManager != nullptr) {
        transferHandle = transferManager->DownloadFile(bucket_name, key_name, file_name);
    }
}
// --------------------------------------------------------------------------
void S3Client::downloadDirectory(const Aws::String &bucket_name,
                                 const Aws::String &key_name,
                                 const Aws::String &dir_name)
{
    LogMgr::debug(Q_FUNC_INFO, dir_name.c_str());
    transferManager = Aws::Transfer::TransferManager::Create(transferConfig);
    if(transferManager != nullptr) {
        transferManager->DownloadToDirectory(dir_name, bucket_name, key_name);
    }
}
// --------------------------------------------------------------------------
const Aws::String S3Client::ALLOCATION_TAG = "QTS3Client";
