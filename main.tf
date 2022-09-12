terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.27"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-northeast-1"
}

variable "bucket-name" {
  type = string
}


#Resource to create s3 bucket
resource "aws_s3_bucket" "tf-state-bucket"{
  bucket = var.bucket-name

  tags = {
    Name = "abc_demo"
  }
}

#Resource to enable versioning 
resource "aws_s3_bucket_versioning" "tf-state-versioning" {
  bucket = var.bucket-name
  versioning_configuration {
    status = "Enabled"
  }
}

#Resource to enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "tf-state-encryption" {
  bucket = var.bucket-name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Adds an ACL to bucket
resource "aws_s3_bucket_acl" "state-bucket_acl" {
  bucket = var.bucket-name
  acl    = "private"
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "state-bucket-public_block" {
  bucket = var.bucket-name
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
