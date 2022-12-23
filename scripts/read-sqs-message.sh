#!/bin/bash
source ./setenv.sh
cmd="awslocal sqs receive-message --queue-url http://localhost:4567/000000000000/ls-sqs-demo"
echo $cmd
exec $cmd
