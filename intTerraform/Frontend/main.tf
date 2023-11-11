provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"

}

# Cluster
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "ecomapp-cluster"
  tags = {
    Name = "ecom-ecs"
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "/ecs/ecom-logs"

  tags = {
    Application = "ecom-app"
  }
}

# Task Definition
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "ecom-task"

  container_definitions = <<EOF
  [
  {
      "name": "ecom-containerF",
      "image": "jmo10/ecommfe",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/ecom-logs",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000
        }
      ]
    }
  ]

  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::104325197445:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::104325197445:role/ecsTaskExecutionRole"
  
}

# ECS Service
resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "ecom-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.ingress_app.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecom-app.arn
    container_name   = "ecom-containerF"
    container_port   = 3000
  }

}
