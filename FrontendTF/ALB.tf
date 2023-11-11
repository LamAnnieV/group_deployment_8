#Target Group
resource "aws_lb_target_group" "ecom-app" {
  name        = "ecom-app"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.ecom_app]
}


data "aws_vpc" "D8-VPC" {
  vpc_id = "vpc-07b9eeeceeed76834"
}

data "aws_subnet" "public_a" {
  subnet_id = "subnet-01249b7ad6ecbca1b"
}

data "aws_subnet" "public_b" {
  subnet_id = "subnet-00a5adc02b96b082f"
}

data "aws_security_group" "http" {
  name        = "httpalb"
}

data "aws_subnet" "public_b" {
  subnet_id = "subnet-00a5adc02b96b082f"
}

data "aws_internet_gateway" "igw" {
  gateway_id             = "igw-0a5ab4d510033a156"
}

#Application Load Balancer
resource "aws_alb" "ecom_app" {
  name               = "ecom-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]

  security_groups = [
    aws_security_group.http.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "ecom_app_listener" {
  load_balancer_arn = aws_alb.ecom_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecom-app.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.ecom_app.dns_name}"
}
