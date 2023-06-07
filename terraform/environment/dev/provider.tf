terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }  
  backend "s3" {
    bucket = "tf-aws-my-saas-company"
    region = "eu-west-1"
    key = "dev/terraform.tfstate"
    encrypt = true
    dynamodb_table  = "dynamodb-state-locking"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_s3_bucket" "terraform_state" {
bucket = "tf-aws-my-saas-company"
# Enable versioning so we can see the full revision history of our state files
versioning {
enabled = true
      }
# Enable server-side encryption by default
# server_side_encryption_configuration {
# rule {
#   apply_server_side_encryption_by_default {
#     sse_algorithm = "AES256"
#           }
#       }
#    }
}

resource "aws_dynamodb_table" "terraform_locks" {
name         = "terraform-locks"
billing_mode = "PAY_PER_REQUEST"
hash_key     = "LockID"
attribute {
name = "LockID"
type = "S"s
      }
}
