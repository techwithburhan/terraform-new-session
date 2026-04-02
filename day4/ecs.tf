# ─── ECR REPOSITORY ──────────────────────────────────────────────────
resource "aws_ecr_repository" "app" {
  name                 = "day4-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "day4-ecr" }
}

# ─── ECS CLUSTER ─────────────────────────────────────────────────────
resource "aws_ecs_cluster" "main" {
  name = "day4-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = { Name = "day4-ecs-cluster" }
}

# ─── ECS TASK DEFINITION ─────────────────────────────────────────────
resource "aws_ecs_task_definition" "app" {
  family                   = "day4-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn

  container_definitions = jsonencode([{
    name      = "app"
    image     = "${aws_ecr_repository.app.repository_url}:${var.ecr_image_tag}"
    essential = true

    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/day4-app"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

# ─── CLOUDWATCH LOG GROUP FOR ECS ────────────────────────────────────
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/day4-app"
  retention_in_days = 7
}
