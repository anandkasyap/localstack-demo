#!/bin/bash
source ./setenv.sh
echo "listing all available S3 Buckets"
list_s3_buckets_cmd="awslocal s3api list-buckets"
echo $list_s3_buckets_cmd
s3_buckets=`exec $list_s3_buckets_cmd`
echo $s3_buckets
echo "listing all available SQS Queues"
list_sqs_queues_cmd="awslocal sqs list-queues"
echo $list_sqs_queues_cmd
sqs_queues=`exec $list_sqs_queues_cmd`
echo $sqs_queues
echo "listing all available Firehose Delivery Streams"
list_firehose_streams_cmd="awslocal firehose list-delivery-streams"
echo $list_firehose_streams_cmd
firehose_streams=`exec $list_firehose_streams_cmd`
echo $firehose_streams
