resource "aws_ecr_lifecycle_policy" "policy" {
  repository = aws_ecr_repository.repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep only the last 5 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution_role" {
  name               = "image_terra_exec_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json
}

data "aws_iam_policy" "aws_app_runner_ecr_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy_attachment" "app_runner_ecr_access_attach" {
  role       = aws_iam_role.execution_role.name
  policy_arn = data.aws_iam_policy.aws_app_runner_ecr_access.arn
}

// Attach CloudWatchLogsFullAccess policy

data "aws_iam_policy" "ecs_cloud_watch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_cloud_watch" {
  role       = aws_iam_role.execution_role.name
  policy_arn = data.aws_iam_policy.ecs_cloud_watch.arn
}


data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name               = "image_terra_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

// Attach AmazonS3FullAccess policy

data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access_attach" {
  role       = aws_iam_role.task_role.name
  policy_arn = data.aws_iam_policy.s3_full_access.arn
}

// Attach AmazonDynamoDBFullAccess policy

data "aws_iam_policy" "dynamodb_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access_attach" {
  role       = aws_iam_role.task_role.name
  policy_arn = data.aws_iam_policy.dynamodb_full_access.arn
}

resource "aws_cloudwatch_log_group" "image_terra_cloudwatch_log_group" {
  name              = "/ecs/image_cloudwatch_log_group"
  retention_in_days = 14
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}