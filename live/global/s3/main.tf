provider "aws" {
    region = "eu-west-2"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket = "s3-terraform-bucket-first"

    #Prevent accidental deletion of this S3 bucket
    lifecycle {
        prevent_destroy = true
    }

    #Enable versioning so we can see the full revision history of our state files
    #versioning {
    #    enabled = true
    #}
    #In the aws_s3_bucket_versioning resource

    #Enable server-side encryption by default
    #server_side_encryption_configuration {
    #    rule {
    #        apply_server_side_encryption_by_default {
    #            sse_algorithm = "AES256"
    #        }
    #    }
    #}
    #In the aws_s3_bucket_server_side_encryption_configuration
}

resource "aws_s3_bucket_versioning" "versioning_t_s_bucket" {
    bucket = aws_s3_bucket.terraform_state_bucket.id
    versioning_configuration {
      status = "Enabled"
    }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_sse_config" {
    bucket = aws_s3_bucket.terraform_state_bucket.id

    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
    }
}


resource "aws_dynamodb_table" "terraform_locks" {
    name = "s3-terraform-bucket-first-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}

terraform {
    backend "s3" {
        bucket = "s3-terraform-bucket-first"
        key = "global/s3/terraform.tfstate"
        region = "eu-west-2"
    

    dynamodb_table = "s3-terraform-bucket-first-locks"
    encrypt = true
    }
}

