# ─── IAM ROLE: LAMBDA EXECUTION ──────────────────────────────────────
resource "aws_iam_role" "lambda_exec" {
  name = "day4-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ─── IAM ROLE: ECS TASK EXECUTION ────────────────────────────────────
resource "aws_iam_role" "ecs_task_exec" {
  name = "day4-ecs-task-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ─── IAM POLICY: S3 READ-ONLY (custom example) ───────────────────────
resource "aws_iam_policy" "s3_read" {
  name        = "day4-s3-read-policy"
  description = "Allow reading from specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = ["arn:aws:s3:::my-app-bucket", "arn:aws:s3:::my-app-bucket/*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.s3_read.arn
}
