#!/bin/bash
source ./setenv.sh
echo "Enter fully qualified path of the File to be uploaded:"
read FILE_PATH
echo "Enter S3 Key:"
read S3_KEY
cmd="awslocal s3 cp ${FILE_PATH} s3://ls-s3-demo/${S3_KEY}"
echo $cmd
exec $cmd
