output "s3_bucket_name" {
  value = aws_s3_bucket.app_data.bucket
}

output "sns_alerts_arn" {
  value = aws_sns_topic.alerts.arn
}

output "cloudwatch_dashboard_url" {
  value = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}
