# ─── S3 BUCKET FOR REMOTE STATE ──────────────────────────────────────
# Create this first (terraform apply), then enable the backend block in providers.tf
resource "aws_s3_bucket" "tf_state" {
  bucket        = var.bucket_name
  force_destroy = false # Never delete non-empty state bucket accidentally

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-tf-state"
    Purpose = "terraform-remote-state"
  })
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled" # Keep history of all state file versions
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ─── DYNAMODB TABLE FOR STATE LOCKING ────────────────────────────────
resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-tf-lock"
    Purpose = "terraform-state-lock"
  })
}
