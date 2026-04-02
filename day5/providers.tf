terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-unique-name"
    key            = "day5/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    # Workspaces automatically prefix state key: day5/env:/dev/terraform.tfstate
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "terraform-learning"
      Day         = "day5"
      ManagedBy   = "terraform"
      Environment = terraform.workspace
    }
  }
}
