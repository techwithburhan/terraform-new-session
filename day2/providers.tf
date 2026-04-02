terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # ── Remote State Backend (S3 + DynamoDB) ──────────────────────────
  # Uncomment after creating the S3 bucket and DynamoDB table manually
  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket-unique-name"
  #   key            = "day2/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "terraform-learning"
      Day       = "day2"
      ManagedBy = "terraform"
    }
  }
}
