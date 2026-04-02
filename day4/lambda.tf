# ─── LAMBDA FUNCTION ─────────────────────────────────────────────────
# Zip the inline Python code for demo (in real projects use a build pipeline)
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"

  source {
    content  = <<-EOF
      import json

      def handler(event, context):
          print("Event received:", json.dumps(event))
          return {
              "statusCode": 200,
              "body": json.dumps({"message": "Hello from Day 4 Lambda!"})
          }
    EOF
    filename = "lambda_function.py"
  }
}

resource "aws_lambda_function" "api_handler" {
  function_name    = "day4-api-handler"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.handler"
  runtime          = var.lambda_runtime
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  memory_size      = 128

  environment {
    variables = {
      ENV = var.environment
    }
  }

  tags = { Name = "day4-lambda" }
}

# ─── CLOUDWATCH LOG GROUP FOR LAMBDA ─────────────────────────────────
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.api_handler.function_name}"
  retention_in_days = 7
}
