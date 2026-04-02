output "lambda_function_name" {
  value = aws_lambda_function.api_handler.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.api_handler.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecr_repo_url" {
  description = "Push Docker images here"
  value       = aws_ecr_repository.app.repository_url
}
