resource "aws_lb" "load_balancer" {
  name               = "image-load-balancer-terra"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  tags = {
    Name = "image-load"
  }
}

resource "aws_lb_target_group" "image_target" {
  name     = "image-target-group-terra"
  port     = 8080 # replace with the port your app is running on
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/images/actuator/check"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6 # should be less than the interval
    port                = "traffic-port"
  }
}

resource "aws_lb_listener" "image_listener_terra" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.image_target.arn
  }
}

resource "aws_ecs_cluster" "image_cluster_terra" {
  name = "image_recognition-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}