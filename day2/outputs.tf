output "state_bucket_name" {
  description = "S3 bucket for Terraform remote state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "dynamodb_lock_table" {
  description = "DynamoDB table for state locking"
  value       = aws_dynamodb_table.tf_lock.name
}

output "selected_instance_type" {
  description = "Instance type selected for this environment"
  value       = local.selected_type
}
