#!/bin/bash
source ./setenv.sh
echo "Please enter the text that should be sent to firehose"
read INPUT_TEXT
cmd="awslocal firehose put-record --delivery-stream-name ls-firehose-demo --record {\"Data\":\"${INPUT_TEXT}\"}"
echo $cmd
exec $cmd
