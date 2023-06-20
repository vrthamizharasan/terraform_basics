//--networkin/main.tf -----

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
  result_count  = var.max_subnet
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
  count = var.public_sn_count
  vpc_id = aws_vpc.mtc_vpc.id 
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true 
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "mtc-public-${count.index + 1 }"
  }
}

resource "aws_route_table_association" "mtc_public_assoc" {
  count = var.public_sn_count
  subnet_id = aws_subnet.mtc_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.mtc_public_rt.id 
}

resource "aws_subnet" "mtc_private_subnet" {
  count = var.private_sn_count
  vpc_id = aws_vpc.mtc_vpc.id 
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = false 
  availability_zone = random_shuffle.az_list.result[count.index]
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

variable "public_sn_count" { }
variable "private_sn_count" { }

varaible "max_subnet" { }

output vpc_id  {
  value = aws_vpc.mtc_vpc.id
}


// [for i in range(2,8,2) : cidrsubnet("10.0.0.0/16" , 8 , i)]

module "networking" {
  source = "./networking"
  vpc_cidr = "10.0.0.0/16"
  public_sn_count = 2
  private_sn_count = 5
  max_subnet = 20
  public_cidrs =   [for i in range(2,255,2) : cidrsubnet("10.0.0.0/16" , 8 , i)]
  private_cidrs = [for i in range(1,255,2) : cidrsubnet("10.0.0.0/16" , 8 , i)]

}

//creating the internet gateway 
 
resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id 
  tags = {
    Name = "mtc_igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id 
  //gateway_id = aws_internet_gateway.mtc_internet_gateway.id 
  tags = {
    Name  = "mtc_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.mtc_public_rt.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_default_route_table" "mtc_private_rt" {
  default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id
  tags = {
    Name  = "mtc_private"
  }
}
