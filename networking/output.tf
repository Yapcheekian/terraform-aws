output "vpc_id" {
  value = aws_vpc.yap_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.yap_rds_subnet_group.*.name
}

output "db_security_group" {
  value = [aws_security_group.yap_sg["private"].id]
}