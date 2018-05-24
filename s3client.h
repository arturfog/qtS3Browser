#ifndef S3CLIENT_H
#define S3CLIENT_H

#include <aws/core/Aws.h>
#include <aws/core/client/AWSError.h>
#include <aws/core/client/ClientConfiguration.h>
#include <aws/core/client/AWSClient.h>

#include <aws/core/utils/memory/stl/AWSString.h>

#include <aws/s3/S3Client.h>

#include <string>

class S3Client {
private:
    std::shared_ptr<Aws::S3::S3Client> s3_client;
    std::unique_ptr<Aws::Client::ClientConfiguration> config;
    static const Aws::String ALLOCATION_TAG;
public:
    S3Client() : config(new Aws::Client::ClientConfiguration()) {
        init();
    }

    void init();

    void deleteObject(const Aws::String &bucket_name, const Aws::String &key_name);

    void downloadFile(const Aws::String &bucket_name, const Aws::String &key_name);

    void uploadFile(const Aws::String &bucket_name, const Aws::String &key_name,
                    const Aws::String &file_name);

    void listBuckets();
};



#endif // S3CLIENT_H