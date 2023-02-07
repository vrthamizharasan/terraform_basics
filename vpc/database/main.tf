resource "aws_db_instance" "rds_instance" {
  allocated_storage     = var.db_storage #10
  db_name               = var.db_name #"mydb"
  engine                = "mysql"
  engine_version        = var.db_engineversion #"5.7"
  instance_class        = var.db_instancetype #"db.t2.micro"
  username              = var.dbusername #"applread"
  password              = var.dbpassword #"password@123"
  skip_final_snapshot   = var.snap #true 
  db_subnet_group_name  = var.db_subnet_group_name
  identifier            = var.dbidentifier #"mydbid"
  vpc_security_group_ids = var.vpc_security_group_ids
}
