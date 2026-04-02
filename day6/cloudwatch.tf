# ─── SNS TOPIC FOR ALERTS ────────────────────────────────────────────
resource "aws_sns_topic" "alerts" {
  name = "day6-${var.environment}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ─── CLOUDWATCH DASHBOARD ────────────────────────────────────────────
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "day6-${var.environment}-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type       = "metric"
        x          = 0
        y          = 0
        width      = 12
        height     = 6
        properties = {
          title  = "EC2 CPU Utilization"
          region = var.aws_region
          metrics = [
            ["AWS/EC2", "CPUUtilization"]
          ]
          period = 300
          stat   = "Average"
          view   = "timeSeries"
        }
      },
      {
        type       = "metric"
        x          = 12
        y          = 0
        width      = 12
        height     = 6
        properties = {
          title  = "S3 Bucket Size"
          region = var.aws_region
          metrics = [
            ["AWS/S3", "BucketSizeBytes",
              "BucketName", aws_s3_bucket.app_data.bucket,
            "StorageType", "StandardStorage"]
          ]
          period = 86400
          stat   = "Average"
        }
      }
    ]
  })
}

# ─── BILLING ALARM ────────────────────────────────────────────────────
# Note: Billing alarms must be created in us-east-1 only
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = "day6-monthly-billing"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 86400
  statistic           = "Maximum"
  threshold           = 50 # USD — adjust for your budget
  alarm_description   = "Alert when AWS bill exceeds $50"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    Currency = "USD"
  }
}
