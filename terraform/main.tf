terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = "~> 4.34.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "ls-s3-tf-demo"
  tags   = merge({ "Name" = "ls-s3-tf-demo" }, var.tags)
}

resource "aws_sqs_queue" "sqs-queue" {
  name                       = "ls-sqs-tf-demo"
  receive_wait_time_seconds  = 5
  visibility_timeout_seconds = 30
  tags                       = merge({ "Name" = "ls-sqs-tf-demo" }, var.tags)
}

resource "aws_s3_bucket_notification" "bucket-notification" {
  bucket = aws_s3_bucket.bucket.id
  queue {
    queue_arn = aws_sqs_queue.sqs-queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_kinesis_firehose_delivery_stream" "firehose-stream" {
  name        = "ls-firehose-tf-demo"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = "arn:aws:iam::000000000000:role/test"
    bucket_arn          = aws_s3_bucket.bucket.arn
    buffer_size         = 1
    buffer_interval     = 60
    prefix              = "data/test"
    error_output_prefix = "errors"
  }
  tags = merge({ "Name" = "ls-firehose-tf-demo" }, var.tags)
}
