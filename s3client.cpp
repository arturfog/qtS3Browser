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

#include "s3client.h"

#include <aws/core/auth/AWSCredentialsProvider.h>

#include <aws/core/utils/ratelimiter/DefaultRateLimiter.h>

#include <aws/s3/model/Bucket.h>
#include <aws/s3/model/Object.h>
// Objects
#include <aws/s3/model/GetObjectRequest.h>
#include <aws/s3/model/DeleteObjectRequest.h>
#include <aws/s3/model/PutObjectRequest.h>
#include <aws/s3/model/ListObjectsRequest.h>
// Buckets
#include <aws/s3/model/CreateBucketRequest.h>
#include <aws/s3/model/DeleteBucketRequest.h>


#include <iostream>
#include <fstream>
#include <regex>
/**
 * @brief S3Client::init
 */
void S3Client::init() {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        auto m_limiter = Aws::MakeShared<Aws::Utils::RateLimits::DefaultRateLimiter<>>(ALLOCATION_TAG.c_str(), 200000);
        config->connectTimeoutMs = 30000;
        config->requestTimeoutMs = 30000;
        //config.region = region;
        config->readRateLimiter = m_limiter;
        config->writeRateLimiter = m_limiter;
        config->endpointOverride = "s3.amazonaws.com:9444";
        config->scheme = Aws::Http::Scheme::HTTP;
        std::shared_ptr<Aws::S3::S3Client> s3_client(new Aws::S3::S3Client(*config));
        this->s3_client = s3_client;
        std::cout << "S3Client::init" << std::endl;
    }
    Aws::ShutdownAPI(options);
}
/**
 * @brief S3Client::listObjects
 * @param bucket_name
 * @param key
 * @param list
 */
void S3Client::listObjects(const Aws::String &bucket_name, const Aws::String &key,
                           std::vector<std::string> &list) {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        std::cout << "Objects in S3 bucket: " << bucket_name << " key: " << key << std::endl;

        Aws::S3::Model::ListObjectsRequest objects_request;
        objects_request.WithBucket(bucket_name);
        objects_request.SetDelimiter("/");

        if(key != "") {
            objects_request.SetPrefix(key);
        }
        auto list_objects_outcome = s3_client->ListObjects(objects_request);

        if (list_objects_outcome.IsSuccess())
        {
            Aws::Vector<Aws::S3::Model::Object> object_list =
                    list_objects_outcome.GetResult().GetContents();

           auto common_list = list_objects_outcome.GetResult().GetCommonPrefixes();

           for (auto const &s3_object : common_list)
           {
               std::string item = regex_replace(s3_object.GetPrefix().c_str(), std::regex(key), "");

               list.emplace_back(item);
               std::cout << "* " << s3_object.GetPrefix() << std::endl;
           }

            for (auto const &s3_object : object_list)
            {
                list.emplace_back(s3_object.GetKey().c_str());
                std::cout << "** " << s3_object.GetKey() << std::endl;
            }
        }
        else
        {
            std::cout << "ListObjects error: " <<
                         list_objects_outcome.GetError().GetExceptionName() << " " <<
                         list_objects_outcome.GetError().GetMessage() << std::endl;
        }
        std::cout << "ListObjects done " << std::endl;
    }

    Aws::ShutdownAPI(options);
}
/**
 * @brief S3Client::getObjectInfo
 * @param bucket_name
 * @param key_name
 */
void S3Client::getObjectInfo(const Aws::String &bucket_name, const Aws::String &key_name)
{
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        std::cout << "Object info in S3 bucket: " << bucket_name << std::endl;

        Aws::S3::Model::GetObjectRequest object_request;
        object_request.WithBucket(bucket_name).WithKey(key_name);

        auto get_object_outcome = s3_client->GetObject(object_request);

        if (get_object_outcome.IsSuccess())
        {
            //auto result = get_object_outcome.GetResult();
            //result.GetContentType();
            //result.GetLastModified();
            //result.GetContentLength();
        }
        else
        {
            std::cout << "GetObject error: " <<
                         get_object_outcome.GetError().GetExceptionName() << " " <<
                         get_object_outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}
/**
 * @brief S3Client::createBucket
 * @param bucket_name
 */
void S3Client::createBucket(const Aws::String &bucket_name) {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        Aws::S3::Model::CreateBucketRequest request;
        request.SetBucket(bucket_name);

        auto outcome = s3_client->CreateBucket(request);

        if (outcome.IsSuccess())
        {
            std::cout << "Done!" << std::endl;
        }
        else
        {
            std::cout << "CreateBucket error: "
                << outcome.GetError().GetExceptionName() << std::endl
                << outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}

void S3Client::uploadProgress(const Aws::Transfer::TransferManager* manager, const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle)
{
    std::cout << "Upload Progress: " << handle->GetBytesTransferred() << " of " << handle->GetBytesTotalSize() << " bytes\n";
}

void S3Client::downloadProgress(const Aws::Transfer::TransferManager* manager, const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle)
{
    std::cout << "Download Progress: " << handle->GetBytesTransferred() << " of " << handle->GetBytesTotalSize() << " bytes\n";
}

void S3Client::statusUpdate(const Aws::Transfer::TransferManager *manager, const std::shared_ptr<const Aws::Transfer::TransferHandle> &handle)
{
    std::cout << "Transfer Status = " << static_cast<int>(handle->GetStatus()) << "\n";
}
/**
 * @brief S3Client::getBuckets
 * @param list
 */
void S3Client::getBuckets(std::vector<std::string> &list) {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        auto outcome = s3_client->ListBuckets();

        if (outcome.IsSuccess())
        {
            std::cout << "Your Amazon S3 buckets:" << std::endl;

            Aws::Vector<Aws::S3::Model::Bucket> bucket_list = outcome.GetResult().GetBuckets();

            for (auto const &bucket : bucket_list)
            {
                list.emplace_back(bucket.GetName().c_str());
                std::cout << "  * " << bucket.GetName() << std::endl;
            }

            std::cout << "ListBuckets done " << std::endl;
        }
        else
        {
            std::cout << "ListBuckets error: "
                << outcome.GetError().GetExceptionName() << " - "
                << outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}
/**
 * @brief S3Client::downloadFile
 * @param bucket_name
 * @param key_name
 */
void S3Client::downloadFile(const Aws::String &bucket_name, const Aws::String &key_name) {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        Aws::S3::Model::GetObjectRequest object_request;
        object_request.WithBucket(bucket_name).WithKey(key_name);

        auto get_object_outcome = s3_client->GetObject(object_request);

        if (get_object_outcome.IsSuccess())
        {
            Aws::OFStream local_file;
            local_file.open(key_name.c_str(), std::ios::out | std::ios::binary);
            local_file << get_object_outcome.GetResult().GetBody().rdbuf();
            std::cout << "Done!" << std::endl;
        }
        else
        {
            std::cout << "GetObject error: " <<
                         get_object_outcome.GetError().GetExceptionName() << " " <<
                         get_object_outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}
/**
 * @brief S3Client::deleteObject
 * @param bucket_name
 * @param key_name
 */
void S3Client::deleteObject(const Aws::String &bucket_name, const Aws::String &key_name) {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        std::cout << "Deleting" << key_name << " from S3 bucket: " <<
            bucket_name << std::endl;

        Aws::S3::Model::DeleteObjectRequest object_request;
        object_request.WithBucket(bucket_name).WithKey(key_name);

        auto delete_object_outcome = s3_client->DeleteObject(object_request);

        if (delete_object_outcome.IsSuccess())
        {
            std::cout << "Done!" << std::endl;
        }
        else
        {
            std::cout << "DeleteObject error: " <<
                delete_object_outcome.GetError().GetExceptionName() << " " <<
                delete_object_outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}
/**
 * @brief S3Client::deleteBucket
 * @param bucket_name
 */
void S3Client::deleteBucket(const Aws::String &bucket_name)
{
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        std::cout << "DeleteBucket ["  << bucket_name << "]" << std::endl;
        Aws::S3::Model::DeleteBucketRequest bucket_request;

        bucket_request.SetBucket(bucket_name);

        auto outcome = s3_client->DeleteBucket(bucket_request);

        if (outcome.IsSuccess())
        {
            std::cout << "Done!" << std::endl;
        }
        else
        {
            std::cout << "DeleteBucket error: "
                      << outcome.GetError().GetExceptionName() << " - "
                      << outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}
/**
 * @brief S3Client::createFolder
 * @param bucket_name
 * @param key_name
 */
void S3Client::createFolder(const Aws::String &bucket_name, const Aws::String &key_name) {
    Aws::SDKOptions options;
    Aws::S3::Model::PutObjectRequest object_request;
    Aws::InitAPI(options);
    {
        std::cout << "Uploading to S3 bucket " <<
            bucket_name << " at key " << key_name << std::endl;

        object_request.WithBucket(bucket_name).WithKey(key_name);

        auto put_object_outcome = s3_client->PutObject(object_request);

        if (put_object_outcome.IsSuccess())
        {
            std::cout << "Done!" << std::endl;
        }
        else
        {
            std::cout << "PutObject error: " <<
                put_object_outcome.GetError().GetExceptionName() << " " <<
                put_object_outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}


void S3Client::uploadFile2(const Aws::String &bucket_name, const Aws::String &key_name,
                           const Aws::String &file_name) {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        Aws::Transfer::TransferManagerConfiguration transferConfig(nullptr);
        transferConfig.s3Client = s3_client;

        transferConfig.transferStatusUpdatedCallback = &statusUpdate;

        transferConfig.uploadProgressCallback = &uploadProgress;

        transferConfig.downloadProgressCallback = &downloadProgress;

        auto transferManager = Aws::Transfer::TransferManager::Create(transferConfig);
        auto transferHandle = transferManager->UploadFile(file_name, bucket_name, key_name,
                                                          "text/plain", Aws::Map<Aws::String, Aws::String>());

        transferHandle->WaitUntilFinished();
    }
    Aws::ShutdownAPI(options);
}

void S3Client::downloadFile2(const Aws::String &bucket_name, const Aws::String &key_name,
                           const Aws::String &file_name) {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        Aws::Transfer::TransferManagerConfiguration transferConfig(nullptr);
        transferConfig.s3Client = s3_client;

        transferConfig.transferStatusUpdatedCallback = &statusUpdate;

        transferConfig.uploadProgressCallback = &uploadProgress;

        transferConfig.downloadProgressCallback = &downloadProgress;

        auto transferManager = Aws::Transfer::TransferManager::Create(transferConfig);
        auto transferHandle = transferManager->DownloadFile(bucket_name, key_name, file_name);

        transferHandle->WaitUntilFinished();
    }
    Aws::ShutdownAPI(options);
}

void S3Client::uploadFile(const Aws::String &bucket_name, const Aws::String &key_name,
                const Aws::String &file_name) {
    Aws::SDKOptions options;
    Aws::S3::Model::PutObjectRequest object_request;

    Aws::InitAPI(options);
    {
        std::cout << "Uploading " << file_name << " to S3 bucket " <<
            bucket_name << " at key " << key_name << std::endl;

        object_request.WithBucket(bucket_name).WithKey(key_name);

        // Binary files must also have the std::ios_base::bin flag or'ed in
        auto input_data = Aws::MakeShared<Aws::FStream>("PutObjectInputStream",
            file_name.c_str(), std::ios_base::in | std::ios_base::binary);

        object_request.SetBody(input_data);

        auto put_object_outcome = s3_client->PutObject(object_request);

        if (put_object_outcome.IsSuccess())
        {
            std::cout << "Done!" << std::endl;
        }
        else
        {
            std::cout << "PutObject error: " <<
                put_object_outcome.GetError().GetExceptionName() << " " <<
                put_object_outcome.GetError().GetMessage() << std::endl;
        }
    }
    Aws::ShutdownAPI(options);
}

const Aws::String S3Client::ALLOCATION_TAG = "QTS3Client";
