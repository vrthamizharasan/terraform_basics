module "networking" {
    source = "./networking"
    vpc_cidrange  =  local.vpc_cidr
    accessip = var.accessip
    security_group = local.security_group
    pubnet_sn_count = 2
    prinet_sn_count = 2
    max_subnet = 20
    public_cidrs = [ for i in range(2, 255, 2): cidrsubnet(local.vpc_cidr , 8 , i)]
    private_cidrs = [ for i in range(1, 255, 2): cidrsubnet(local.vpc_cidr , 8 , i)]

}


module "database" {
    source = "./database"
    db_storage = 10
    db_name = var.db_name
    db_engineversion = "5.7"
    db_instancetype = "db.t2.micro"
    dbusername = var.dbusername
    dbpassword = var.dbpassword
    snap = true 
    db_subnet_group_name = module.networking.rds_subnet_group_name[0]
    dbidentifier = "mydbid"
    vpc_security_group_ids = [module.networking.db_security_group_id]
}
        
module "loadbalancer" {
  source = "./loadbalancer"
  public_sg = module.networking.public_sg
  publicsubnet = module.networking.publicsubnet
}        
