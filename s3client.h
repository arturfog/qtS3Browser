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

    static const Aws::String ALLOCATION_TAG;
    static std::function<void(const std::string&)> m_func;
public:
    S3Client() : config(new Aws::Client::ClientConfiguration()) {
        init();
        Aws::InitAPI(options);
    }

    ~S3Client() {
        Aws::ShutdownAPI(options);
    }

    void init();

    void listObjects(const Aws::String &bucket_name, const Aws::String &key,
                     std::vector<std::string> &list);

    void getObjectInfo(const Aws::String &bucket_name, const Aws::String &key_name);

    void deleteObject(const Aws::String &bucket_name, const Aws::String &key_name);
    // DELETE BUCKET
    void deleteBucket(const Aws::String &bucket_name);
    static void deleteBucketHandler(const Aws::S3::S3Client* client,
                                    const Aws::S3::Model::DeleteBucketRequest& request,
                                    const Aws::S3::Model::DeleteBucketOutcome& outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    // DOWNLOAD
    void downloadFile(const Aws::String &bucket_name, const Aws::String &key_name);

    void downloadFile2(const Aws::String &bucket_name, const Aws::String &key_name,
                     const Aws::String &file_name);

    void uploadFile2(const Aws::String &bucket_name, const Aws::String &key_name,
                     const Aws::String &file_name);
    void uploadFile(const Aws::String &bucket_name, const Aws::String &key_name,
                    const Aws::String &file_name);

    void createFolder(const Aws::String &bucket_name, const Aws::String &key_name);

    // GET BUCKETS
    void getBuckets(std::function<void(const std::string&)> func);
    static void getBucketsHandler(const Aws::S3::S3Client* client,
                           const Aws::S3::Model::ListBucketsOutcome& outcome,
                           const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    // CREATE BUCKET
    void createBucket(const Aws::String &bucket_name);
    static void createBucketHandler(const Aws::S3::S3Client* client,
                                    const Aws::S3::Model::CreateBucketRequest& request,
                                    const Aws::S3::Model::CreateBucketOutcome& outcome,
                                    const std::shared_ptr<const Aws::Client::AsyncCallerContext>& context);
    //
    static void uploadProgress(const Aws::Transfer::TransferManager* manager, const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle);
    static void downloadProgress(const Aws::Transfer::TransferManager* manager, const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle);
    static void statusUpdate(const Aws::Transfer::TransferManager* manager, const std::shared_ptr<const Aws::Transfer::TransferHandle>& handle);
};



#endif // S3CLIENT_H
