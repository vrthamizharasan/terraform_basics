//--networkin/main.tf -----

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "mtc_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true 
  enable_dns_support = true 
  tags = {
    Name = "mtc_vpc-${random_integer.random.id}"
  }
}

variable "vpc_cidr" {}

output vpc_id  {
  value = aws_vpc.mtc_vpc.id
}


// main.tf ----
module "networking" {
  source = "./networking"
  vpc_cidr = "10.0.0.0/16"
}
