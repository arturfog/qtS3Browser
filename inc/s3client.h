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

#ifndef S3CLIENT_H
#define S3CLIENT_H

#include <aws/core/Aws.h>
#include <aws/core/client/AWSError.h>
#include <aws/core/client/ClientConfiguration.h>
#include <aws/core/client/AWSClient.h>

#include <aws/s3/model/DeleteBucketRequest.h>

#include <aws/core/utils/memory/stl/AWSString.h>
#include <aws/core/utils/threading/Executor.h>
//
#include <aws/s3/S3Client.h>
//
#include <aws/transfer/TransferManager.h>
#include <aws/transfer/TransferHandle.h>

#include <string>

class S3Client {
private:
    std::shared_ptr<Aws::S3::S3Client> s3_client;
    std::unique_ptr<Aws::Client::ClientConfiguration> config;
    Aws::SDKOptions options;
    std::shared_ptr<Aws::Transfer::TransferHandle> transferHandle;

    static const Aws::String ALLOCATION_TAG;
    static std::function<void(const std::string&)> m_func;
    static std::function<void(const unsigned long bytes, const unsigned long total)> m_progressFunc;
    static std::shared_ptr<Aws::Utils::Threading::PooledThreadExecutor> executor;
public:
    struct ObjectInfo_S {
        int size;
        Aws::String type;
        Aws::String etag;
        Aws::Utils::DateTime lastModified;

    } objectInfo;
    /**
     * @brief S3Client
     */
    S3Client() : config(new Aws::Client::ClientConfiguration()) {
        init();
        Aws::InitAPI(options);
        transferHandle = nullptr;
    }

    ~S3Client() {
        Aws::ShutdownAPI(options);
    }

    void init();
    // LIST OBJECTS
    /**
     * @brief listObjects
     * @param bucket_name
     * @param key
     * @param func
     */
    void listObjects(const Aws::String &bucket_name, const Aws::String &key,
                     std::function<void(const std::string&)> func);
    /**
     * @brief listObjectsHandler
     * @param client
     * @param request
     * @param outcome
     * @param context
     */
    static void listObjectsHandler(const Aws::S3::S3Client* client,
                                   const Aws::S3::Model::ListObjectsRequest& request,
                                   const Aws::S3::Model::ListObjectsOutcome& outcome,
                                   const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    // DELETE OBJECT
    /**
     * @brief deleteObject
     * @param bucket_name
     * @param key_name
     */
    void deleteObject(const Aws::String &bucket_name, const Aws::String &key_name);
    /**
     * @brief deleteObjectHandler
     * @param client
     * @param request
     * @param outcome
     * @param context
     */
    static void deleteObjectHandler(const Aws::S3::S3Client* client,
                                    const Aws::S3::Model::DeleteObjectRequest& request,
                                    const Aws::S3::Model::DeleteObjectOutcome& outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    // DELETE BUCKET
    /**
     * @brief deleteBucket
     * @param bucket_name
     */
    void deleteBucket(const Aws::String &bucket_name);
    /**
     * @brief deleteBucketHandler
     * @param client
     * @param request
     * @param outcome
     * @param context
     */
    static void deleteBucketHandler(const Aws::S3::S3Client* client,
                                    const Aws::S3::Model::DeleteBucketRequest& request,
                                    const Aws::S3::Model::DeleteBucketOutcome& outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);

    // CREATE FOLDER
    /**
     * @brief createFolder
     * @param bucket_name
     * @param key_name
     */
    void createFolder(const Aws::String &bucket_name, const Aws::String &key_name);
    /**
     * @brief createFolderHandler
     * @param client
     * @param request
     * @param outcome
     * @param context
     */
    static void createFolderHandler(const Aws::S3::S3Client* client,
                                    const Aws::S3::Model::PutObjectRequest& request,
                                    const Aws::S3::Model::PutObjectOutcome& outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    // GET BUCKETS
    /**
     * @brief getBuckets
     * @param func
     */
    void getBuckets(std::function<void(const std::string&)> func);
    static void getBucketsHandler(const Aws::S3::S3Client* client,
                           const Aws::S3::Model::ListBucketsOutcome& outcome,
                           const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    // CREATE BUCKET
    /**
     * @brief createBucket
     * @param bucket_name
     */
    void createBucket(const Aws::String &bucket_name);
    /**
     * @brief createBucketHandler
     * @param client
     * @param request
     * @param outcome
     * @param context
     */
    static void createBucketHandler(const Aws::S3::S3Client* client,
                                    const Aws::S3::Model::CreateBucketRequest& request,
                                    const Aws::S3::Model::CreateBucketOutcome& outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    // DOWNLOAD/UPLOAD
    /**
     * @brief downloadFile
     * @param bucket_name
     * @param key_name
     * @param file_name
     * @param progressFunc
     */
    void downloadFile(const Aws::String &bucket_name,
                      const Aws::String &key_name,
                      const Aws::String &file_name,
                      std::function<void(const unsigned long long bytes, const unsigned long long total)> progressFunc);
    /**
     * @brief uploadFile
     * @param bucket_name
     * @param key_name
     * @param file_name
     * @param progressFunc
     */
    void uploadFile(const Aws::String &bucket_name,
                    const Aws::String &key_name,
                    const Aws::String &file_name,
                    std::function<void(const unsigned long long bytes, const unsigned long long total)> progressFunc);
    /**
     * @brief cancelDownloadUpload
     */
    void cancelDownloadUpload();
    // DOWNLOAD/UPLOAD callbacks
    /**
     * @brief uploadProgress
     * @param manager
     * @param handle
     */
    static void uploadProgress(const Aws::Transfer::TransferManager* manager,
                               const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle);
    /**
     * @brief downloadProgress
     * @param manager
     * @param handle
     */
    static void downloadProgress(const Aws::Transfer::TransferManager* manager,
                                 const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle);
    static void statusUpdate(const Aws::Transfer::TransferManager* manager,
                             const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle);
    static void errorHandler(const Aws::Transfer::TransferManager* manager,
                             const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle,
                             const Aws::Client::AWSError<Aws::S3::S3Errors>& error);
    // GET INFO
    void getObjectInfo(const Aws::String &bucket_name, const Aws::String &key_name);
    static void getObjectInfoHandler(const Aws::S3::S3Client* client,
                                     const Aws::S3::Model::GetObjectRequest& request,
                                     const Aws::S3::Model::GetObjectOutcome& outcome,
                                     const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
};



#endif // S3CLIENT_H
