#!/bin/bash
ROOT_DIR=../
if [ ! -z $1 ]; then
  ROOT_DIR=$1
fi
docker-compose -f $ROOT_DIR/docker-compose-files/docker-compose-ls.yml down

