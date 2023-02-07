module "networking" {
    source = "./networking"
    vpc_cidrange  =  "10.0.0.0/16"
    pubnet_sn_count = 2
    prinet_sn_count = 2
    max_subnet = 20
    public_cidrs = [ for i in range(2, 255, 2): cidrsubnet("10.0.0.0/16" , 8 , i)]
    private_cidrs = [ for i in range(1, 255, 2): cidrsubnet("10.0.0.0/16" , 8 , i)]

}
