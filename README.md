# localstack-demo

This repository consists of a demo on how to use localstack for local development.

## Setup localstack

### Setup AWS Credentials

If you have not setup any AWS Credentials, you should run the below

```
aws configure
```

and set

```
AWS Access Key Id = test
AWS Secret Key    = test
Region = us-east-1
```

To setup localstack, run the `scripts/create-services.sh`

This script will

```
- Start Localstack using the docker-compose-files/docker-compose-ls.yml file.
- Expose localstack on port 4567\. To change this port, please modify the docker-compose-ls.yml
- Create
  - S3 Bucket named ls-s3-demo
  - SQS Queue named ls-sqs-demo
  - Object Creation Bucket Notification between ls-s3-demo and ls-sqs-demo
  - Firehose Delivery Stream ls-firehose-demo which will deliver data as objects on ls-s3-demo
```

To Access localstack using aws cli, you have to run the aws cli as mentioned below

```
   aws --endpoint-url=http://localhost:4567 <<service>> <<cmd>> <<Params>>

   Example:

   aws --endpoint-url=http://localhost:4567 s3 ls s3://ls-s3-demo --recursive
```

Alternatively, you can install awslocal cli binary. If you use awslocal, you don't have to mention --endpoint_url. By default, awslocal points to <http://localhost:4566>. To override the port, you should set an environment variable EDGE_PORT with the new port number

## Setup Aws Local CLI

The instructions to setup awslocal cli can be found [here](https://github.com/localstack/awscli-local)

## Testing LocalStack with awslocal

The scripts folder has some scripts to do basic testing such as

- Writing text to a Firehose Stream
- Writing a file to a Firehose Stream
- Writing an object to a S3 Bucket
- Listing contents of a S3 Bucket
- Testing Bucket Notification when an object is put in the S3 bucket.

### write-text-into-firehose.sh

This script expects you to give a text as input (preferably without any quotes or special characters). Keep in mind that firehose always expects its record in the form of JSON with "Data" as the key.

### write-file-into-firehose.sh

This script expects you to provide a fully qualified file path as input. Since Firehose records should be in JSON Format, JSON blob files should be escaped.

### write-data-into-s3.sh

This script expects you to provide

- a fully qualified file path
- S3 Object key as input. This script will upload the given file as an object in the ls-s3-demo bucket with the key provided as input.

### list-s3-bucket-objects.sh

This script will list the contents of the bucket ls-s3-demo.

### read-sqs-message.sh

This script will read a message from the sqs queue. If you look at the message contents, you'll notice that it is a S3 Bucket Notification which carries metadata about the message and the object related to the notification.

## Test Localstack with Python scripts

There are 2 basic python scripts in the `python` folder. These scripts are just examples on how to access localstack using the AWS SDK.

`To run these scripts, please install boto3`

You can install boto3 using the below command.

`pip3 install boto3`

### s3-write.py

This script

- creates an object with text `This is a sample published into localstack from a python script`
- uploads it into the s3 bucket `ls-s3-demo` with key `test/from/python`

You can validate the script's successful execution by downloading the object using the below command `awslocal s3 cp s3://ls-s3-demo/test/from/python . && cat python && printf "\n"`

### s3-read.py

This script

- reads an object from s3 bucket `ls-s3-demo` with key `test/from/python`
- Prints the content of the object (which should most probably be `This is a sample published into localstack from a python script`)

## Terraform + LocalStack

Terraform recently introduced a terraform plugin called terraform-local, which enables execution of terraform scripts against localstack.

Instructions to install terraform-local can be found [here](https://docs.localstack.cloud/user-guide/integrations/terraform/)

Once installed, you can run terraform-local using `tflocal` command. To run this command, you have to ensure that `terraform` binary is available in your path.

After this, just cd to the `terraform` folder in this repository.

inside this folder, run

```
tflocal init
tflocal plan
tflocal apply
```

Once you do this, you should see the below components created.

```
- S3 Bucket named ls-s3-tf-demo
- SQS Queue named ls-sqs-tf-demo
- Object Creation Bucket Notification between ls-s3-tf-demo and ls-sqs-tf-demo
- Firehose Delivery Stream ls-firehose-tf-demo which will deliver data as objects on ls-s3-tf-demo
- Lambda Function ls-lambda-tf-demo
- API Gateway to Trigger the Lambda function
```

To verify the terraform execution, you can run the below cli commands

```
source scripts/setenv.sh

# List S3 Buckets

awslocal s3api list-buckets

# List SQS Queues

awslocal sqs list-queues

# List Firehose Streams

awslocal firehose list-delivery-streams

# List Lambda functions

awslocal lambda list-functions

# List API Gateways

awslocal apigateway get-rest-apis
```

To invoke the lambda function, you can

- run the `scripts/invoke-lambda.sh`
- trigger the api gateway

### Run invoke-lambda.sh

This script when executed will trigger the lambda function `ls-lambda-tf-demo`. This Lambda function will create an object with key `test/from/python-lambda` in the bucket `ls-s3-demo`. This object should contain the text

```
This is a sample published into localstack from a python script running in a lambda within localstack
```

You can validate this by running the below command

```
awslocal s3 cp s3://ls-s3-demo/test/from/python-lambda . && cat python-lambda && printf "\n"
```

### Trigger API Gateway

To Trigger the API Gateway, you should curl the api gateway endpoint url. You should construct the url by replacing the rest-api-id in the below mentioned pattern.

```
http://localhost:4567/restapis/<<Rest API ID>>/<<STAGE NAME>>/_user_request_/<<URL Resource>>
```

To get the rest api id, you run the below command.

```
awslocal apigateway get-rest-apis
```

You should get a response like the one below.

```
{
    "items": [
        {
            "id": "zwk8gj9rsm",
            "name": "test_lambda_api",
            "description": "proxy to trigger test lambda",
            "createdDate": 1672264325.0,
            "version": "V1",
            "binaryMediaTypes": [],
            "apiKeySource": "HEADER",
            "endpointConfiguration": {
                "types": [
                    "EDGE"
                ]
            },
            "tags": {},
            "disableExecuteApiEndpoint": false
        }
    ]
}
```

Get the value from the id field.

For this API Gateway example, your url should be similar to identify your Rest API ID and replace it in the url given below.

```
http://localhost:4567/restapis/zwk8gj9rsm/test/_user_request_/invoke
```

Here `zwk8gj9rsm` is my rest api id. your url might differ here.

Once you curl a HTTP GET request, you should see the response `"Lambda Invoked Successfully!!"`

You can validate this by running the below command

```
awslocal s3 cp s3://ls-s3-demo/test/from/python-lambda . && cat python-lambda && printf "\n"
```

You should see the below text

```
This is a sample published into localstack from a python script running in a lambda within localstack, triggered by API Gateway
```

If you look at that text, it clearly states that the lambda function was triggered by API Gateway.
