output "db_security_group_id" {
  value = aws_security_group.public-sg["rds"].id
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.*.name
}

output "vpc_id" {
  value = aws_vpc.testvpc.id 
}
