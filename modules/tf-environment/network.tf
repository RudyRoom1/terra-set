data "aws_vpc" "default" {
  default = true
}

data "aws_region" "current" {}


resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-west-1b"
  tags = {
    Name = "subnet_a"
  }
}


resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-west-1c"
  tags = {
    Name = "subnet_b"
  }
}


resource "aws_security_group" "sg_for_endpoints" {
  name   = var.security_group_name
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = data.aws_vpc.default.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  vpc_id              = data.aws_vpc.default.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id]
  security_group_ids  = [aws_security_group.sg_for_endpoints.id]
}

resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  vpc_id              = data.aws_vpc.default.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id]
  security_group_ids  = [aws_security_group.sg_for_endpoints.id]
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = data.aws_vpc.default.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint" "logs_endpoint" {
  vpc_id              = data.aws_vpc.default.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id]
  security_group_ids  = [aws_security_group.sg_for_endpoints.id]
}