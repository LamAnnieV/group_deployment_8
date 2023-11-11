#Target Group
resource "aws_lb_target_group" "ecom-app" {
  name        = "ecom-app"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id                            #update with actuals ID

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.ecom_app]
}

#Application Load Balancer
resource "aws_alb" "ecom_app" {
  name               = "ecom-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_a.id,                            #update with actuals ID
    aws_subnet.public_b.id,                            #update with actuals ID
  ]

  security_groups = [
    aws_security_group.http.id,                            #update with actuals ID
  ]

  depends_on = [aws_internet_gateway.igw]                            #update with actuals ID
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
