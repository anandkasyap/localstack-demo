#!/bin/bash
source ./setenv.sh
cmd="awslocal s3api list-buckets"
echo $cmd
exec $cmd
