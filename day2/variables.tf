variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment: dev, staging, prod"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "instance_type" {
  description = "EC2 instance type per environment"
  type        = map(string)
  default = {
    dev     = "t2.micro"
    staging = "t3.small"
    prod    = "t3.medium"
  }
}

variable "allowed_cidr_blocks" {
  description = "List of CIDRs allowed to SSH"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "bucket_name" {
  description = "S3 bucket name for remote state"
  type        = string
  default     = "my-terraform-state-bucket-unique-name"
}
