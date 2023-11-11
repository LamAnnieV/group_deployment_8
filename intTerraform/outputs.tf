
output "ecs_cluster_id" {
  value = data.aws_ecs_cluster.aws-ecs-cluster.id
}

output "vpc_id" {
  value = data.aws_vpc.app_vpc.id
}

output "subnet_ida" {
  value = data.aws_subnet.public_a.id
}

output "subnet_idb" {
  value = data.aws_subnet.public_b.id
}

output "alb_security_group_id" {
  value = data.aws_security_group.http.id
}

output "ingress_security_group_id" {
  value = data.aws_security_group.ingress_app.id
}

output "internet_gateway" {
  value = data.aws_internet_gateway.igw.id
}
