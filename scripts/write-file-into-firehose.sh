#!/bin/bash
source ./setenv.sh
echo "Enter fully qualified path of the File to be uploaded"
read FILE_PATH
cmd="awslocal firehose put-record --delivery-stream-name ls-firehose-demo --record file://${FILE_PATH}"
echo $cmd
exec $cmd
