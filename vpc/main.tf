locals {
  vpc_cidr = "10.0.0.0/16"
}

module "networking" {
    source = "./networking"
    vpc_cidrange  =  local.vpc_cidr
    accessip = var.accessip
    pubnet_sn_count = 2
    prinet_sn_count = 2
    max_subnet = 20
    public_cidrs = [ for i in range(2, 255, 2): cidrsubnet(local.vpc_cidr , 8 , i)]
    private_cidrs = [ for i in range(1, 255, 2): cidrsubnet(local.vpc_cidr , 8 , i)]

}
