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
