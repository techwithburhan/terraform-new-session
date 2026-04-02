variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "lambda_runtime" {
  type    = string
  default = "python3.12"
}

variable "ecr_image_tag" {
  description = "Docker image tag for ECS task"
  type        = string
  default     = "latest"
}
