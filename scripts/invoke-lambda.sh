#!/bin/bash
source ./setenv.sh
echo "Enter text for lambda payload"
read INPUT
cmd="awslocal lambda invoke --function-name ls-lambda-tf-demo --invocation-type RequestResponse ./output"
echo $cmd
exec $cmd
