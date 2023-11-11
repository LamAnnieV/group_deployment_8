output "ecs_cluster_id" {
  value = aws_ecs_cluster.NAME.id
}

output "vpc_id" {
  value = aws_vpc.NAME.id
}

output "subnet_ida" {
  value = aws_subnet.NAME.id
}

output "subnet_idb" {
  value = aws_subnet.NAME.id
}

output "alb_security_group_id" {
  value = aws_security_group.NAME.id
}

output "internet_gateway" {
  value = aws_internet_gateway.NAME.id
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

# Cluster
data "aws_ecs_cluster" "existing_ecs_cluster" {
  cluster_name = "ecomapp-cluster"
}
