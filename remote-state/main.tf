provider "aws" {
  region = "ap-southeast-2"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.45"
    }
  }
}

resource "aws_s3_bucket" "terraform_state"{
  bucket = "logiczoo-terraform-state-zookeeper"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name         = "logiczoo-terraform-state-lock-zookeeper"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
