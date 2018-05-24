#include "s3client.h"

#include <aws/core/auth/AWSCredentialsProvider.h>

#include <aws/core/utils/ratelimiter/DefaultRateLimiter.h>

#include <aws/s3/model/Bucket.h>
#include <aws/s3/model/GetObjectRequest.h>
#include <aws/s3/model/DeleteObjectRequest.h>
#include <aws/s3/model/PutObjectRequest.h>

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
        config->endpointOverride = "172.17.0.2:9444";
        config->scheme = Aws::Http::Scheme::HTTP;
        std::shared_ptr<Aws::S3::S3Client> s3_client(new Aws::S3::S3Client(*config));
        this->s3_client = s3_client;
    }
    Aws::ShutdownAPI(options);
}

void S3Client::listBuckets() {
    Aws::SDKOptions options;
    Aws::InitAPI(options);
    {
        auto outcome = s3_client->ListBuckets();

        if (outcome.IsSuccess())
        {
            std::cout << "Your Amazon S3 buckets:" << std::endl;

            Aws::Vector<Aws::S3::Model::Bucket> bucket_list =
                outcome.GetResult().GetBuckets();

            for (auto const &bucket : bucket_list)
            {
                std::cout << "  * " << bucket.GetName() << std::endl;
            }
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

void S3Client::downloadFile(const Aws::String &bucket_name, const Aws::String &key_name) {
        Aws::S3::Model::GetObjectRequest getObjectRequest;
        getObjectRequest.SetBucket(bucket_name);
        getObjectRequest.SetKey(key_name);
}

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

void S3Client::uploadFile(const Aws::String &bucket_name, const Aws::String &key_name,
                const Aws::String &file_name) {
    Aws::SDKOptions options;
    Aws::S3::Model::PutObjectRequest object_request;
    Aws::InitAPI(options);
    {
        std::cout << "Uploading " << file_name << " to S3 bucket " <<
            bucket_name << " at key " << key_name << std::endl;

        object_request.WithBucket(bucket_name).WithKey(key_name);

//        // Binary files must also have the std::ios_base::bin flag or'ed in
//        //auto input_data = Aws::MakeShared<Aws::FStream>("PutObjectInputStream",
//        //    file_name.c_str(), std::ios_base::in | std::ios_base::binary);

//        //object_request.SetBody(input_data);

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
