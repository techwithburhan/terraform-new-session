variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# ── Workspace-aware sizing map ─────────────────────────────────────────
# Usage: terraform workspace new dev
#        terraform workspace select prod
locals {
  workspace = terraform.workspace

  env_config = {
    default = {
      instance_type = "t2.micro"
      min_size      = 1
      max_size      = 2
      desired       = 1
    }
    dev = {
      instance_type = "t2.micro"
      min_size      = 1
      max_size      = 2
      desired       = 1
    }
    staging = {
      instance_type = "t3.small"
      min_size      = 1
      max_size      = 3
      desired       = 2
    }
    prod = {
      instance_type = "t3.medium"
      min_size      = 2
      max_size      = 6
      desired       = 3
    }
  }

  # Fallback to "default" if workspace not mapped
  config = lookup(local.env_config, local.workspace, local.env_config["default"])
}
