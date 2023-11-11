#Target Group
resource "aws_lb_target_group" "ecom-app-FE" {
  name        = "ecom-app-FE"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-0275fe41113f0ca69"                           #update with actual ID

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
    "subnet-0297bfe1d4f5960e0",                            #update with actual ID
    "subnet-0be4f13b9700414df",                            #update with actual ID
  ]

  security_groups = [
    "sg-0b91d06ecfe3579da",                            #update with actual ID
  ]

  #depends_on = ["igw-029226251b6b77124"]                            #update with actual ID
}

resource "aws_alb_listener" "ecom_app_listener" {
  load_balancer_arn = aws_alb.ecom_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecom-app-FE.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.ecom_app.dns_name}"
}
