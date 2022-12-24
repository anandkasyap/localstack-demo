#!/bin/bash
source ./setenv.sh
cmd="awslocal lambda invoke --function-name ls-lambda-tf-demo --invocation-type RequestResponse ./output"
echo $cmd
exec $cmd
