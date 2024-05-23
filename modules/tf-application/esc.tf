

resource "aws_ecs_task_definition" "image_ecs_terra" {
  family                   = "image_ecs_terra"
  network_mode             = "awsvpc"
  memory                   = "3072"
  cpu                      = "1024"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = "image-ecs-terra-container"
      image     = var.image_uri
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.image_terra_cloudwatch_log_group.name
          awslogs-region        = "us-west-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        {
          name  = "ACCESS_KEY_ID"
          value = "example-value"
        },
        {
          name  = "BUCKET_NAME"
          value = var.bucket_name
        },
        {
          name  = "REGION"
          value = var.region_name
        },
        {
          name  = "SECRET_ACCESS_KEY"
          value = "example-value"
        },
        {
          name  = "TABLE_NAME"
          value = var.dynamodb_name
        },
      ]
    }
  ])
}

resource "aws_ecs_service" "image_ecs_service_terra" {
  name            = "image-terra-service"
  cluster         = aws_ecs_cluster.image_cluster_terra.id
  task_definition = aws_ecs_task_definition.image_ecs_terra.arn
  launch_type     = "FARGATE"
  desired_count   = 0

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.image_target.arn
    container_name   = "image-ecs-terra-container"
    container_port   = 8000
  }

  depends_on = [
    aws_lb_listener.image_listener_terra,
  ]
}
