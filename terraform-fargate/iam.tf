# ECS Task Execution Role — used by ECS to pull images, write logs, and read secrets
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.ec2_task_execution_role_name}-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# AWS-managed policy covering ECR pull + CloudWatch logs
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Secrets Manager access (referenced in secrets.tf)
resource "aws_iam_role_policy" "secrets_access" {
  name = "cb-app-secrets-access-${terraform.workspace}"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
    }]
  })
}

# ECS Auto Scale Role — used by Application Auto Scaling to adjust desired count
resource "aws_iam_role" "ecs_auto_scale_role" {
  name = "${var.ecs_auto_scale_role_name}-${terraform.workspace}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "application-autoscaling.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-auto-scale-role-policy-attachment" {
  role       = aws_iam_role.ecs_auto_scale_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}