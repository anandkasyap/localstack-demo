#!/bin/bash
source ./setenv.sh
cmd="awslocal s3 ls s3://ls-s3-demo --recursive"
echo $cmd
exec $cmd
