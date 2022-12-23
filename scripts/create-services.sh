#!/bin/bash
if [ -z $1 ]; then
  echo "Please provide root folder location"
  exit 1
fi
ROOT_DIR=$1
docker-compose -f $ROOT_DIR/docker-compose-files/docker-compose-ls.yml down

docker-compose -f $ROOT_DIR/docker-compose-files/docker-compose-ls.yml up -d

# Create S3 bucket
aws --endpoint-url=http://localhost:4567 s3api create-bucket --bucket ls-s3-demo

# Create SQS Queue
aws --endpoint-url=http://localhost:4567 sqs create-queue --queue-name ls-sqs-demo

# Configure S3 -> SQS Notification
aws --endpoint-url=http://localhost:4567 s3api put-bucket-notification-configuration --bucket ls-s3-demo --notification-configuration file://$ROOT_DIR/configurations/s3-notification-configuration.json

# Create Firehose Stream
aws --endpoint-url=http://localhost:4567 firehose create-delivery-stream --delivery-stream-name ls-firehose-demo --extended-s3-destination-configuration file://$ROOT_DIR/configurations/firehose-s3-configuration.json
