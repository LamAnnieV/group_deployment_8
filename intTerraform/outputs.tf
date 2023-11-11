
output "ecs_cluster_id" {
  value = aws_ecs_cluster.aws-ecs-cluster.id
}

output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "subnet_ida" {
  value = aws_subnet.public_a.id
}

output "subnet_idb" {
  value = aws_subnet.public_b.id
}

output "alb_security_group_id" {
  value = aws_security_group.http.id
}

output "ingress_sg_BE_id" {
  value = aws_security_group.ingress_app_BE.id
}

output "ingress_sg_FE_id" {
  value = aws_security_group.ingress_app_FE.id
}

output "internet_gateway" {
  value = aws_internet_gateway.igw.id
}
