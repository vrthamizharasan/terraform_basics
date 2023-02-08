module "networking" {
  source          = "./networking"
  vpc_cidrange    = local.vpc_cidr
  accessip        = var.accessip
  security_group  = local.security_group
  pubnet_sn_count = 2
  prinet_sn_count = 2
  max_subnet      = 20
  db_subnet_group = true
  public_cidrs    = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs   = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]

}

module "database" {
  source                 = "./database"
  db_storage             = 10
  db_name                = var.db_name
  db_engineversion       = "5.7"
  db_instancetype        = "db.t2.micro"
  dbusername             = var.dbusername
  dbpassword             = var.dbpassword
  snap                   = true
  db_subnet_group_name   = module.networking.rds_subnet_group_name[0]
  dbidentifier           = "mydbid"
  vpc_security_group_ids = [module.networking.db_security_group_id]
}


module "loadbalancer" {
  source            = "./loadbalancer"
  public_sg         = module.networking.public_sg
  publicsubnet      = module.networking.publicsubnet
  vpc_id            = module.networking.vpc_id
  tg_port           = 80
  tg_protocol       = "HTTP"
  tg_heathythold    = 2
  tg_unhealthythold = 2
  tg_interval       = 30
  tg_timeout        = 3
  lister_port       = 80
  lister_protocol   = "HTTP"
}


module "compute" {
    source = "./compute"
    demo_instance_type = "t2.micro"
    instance_count = 1
    public_sg = module.networking.public_sg
    public_subnet = module.networking.publicsubnet
    vol_size = 10
    key_name = "deploykey"
    pubkey_path = "/home/applread/.ssh/id_rsa.pub"
    user_data_path = "${path.root}/userdata.tpl"
    db_name = var.db_name
    dbusername = var.dbusername
    dbpassword = var.dbpassword
    db_endpoint = module.database.db_endpoint
    target_group_arn = module.loadbalancer.target_group_arn
}
