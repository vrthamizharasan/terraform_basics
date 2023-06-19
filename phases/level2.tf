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

resource "aws_subnet" "mtc_public_subnet" {
  count = length(var.public_cidrs)
  vpc_id = aws_vpc.mtc_vpc.id 
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true 
  availability_zone = ["us-west-2a", "us-west-2b", "us-west-2c","us-west-2d"][count.index]
  tags = {
    Name = "mtc-public-${count.index + 1 }"
  }
}

resource "aws_subnet" "mtc_private_subnet" {
  count = length(var.private_cidrs)
  vpc_id = aws_vpc.mtc_vpc.id 
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = false 
  availability_zone = ["us-west-2a", "us-west-2b", "us-west-2c","us-west-2d"][count.index]
  tags = {
    Name = "mtc-private-${count.index + 1 }"
  }
}


variable "vpc_cidr" {}

variable "public_cidrs" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
}

output vpc_id  {
  value = aws_vpc.mtc_vpc.id
}

module "networking" {
  source = "./networking"
  vpc_cidr = "10.0.0.0/16"
  public_cidrs =  [ "10.0.2.0/24" , "10.0.4.0/24"]
  private_cidrs = [ "10.0.1.0/24" , "10.0.3.0/24" , "10.0.5.0/24"]
}

