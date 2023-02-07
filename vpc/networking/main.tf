resource "random_integer" "priority" {
  min = 1
  max = 50
  }


resource "aws_vpc" "testvpc" {
    cidr_block = var.vpc_cidrange
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "testvpc-${random_integer.priority.id}"
    }

}


data "aws_availability_zones" "available" {
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnet
}


resource "aws_subnet" "public_subnet" {
  count = var.pubnet_sn_count
  vpc_id = aws_vpc.testvpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = random_shuffle.az.result[count.index]
  tags = {
    Name = "public-subnet-${count.index +1}"
  }
}


resource "aws_subnet" "private_subnet" {
  count = var.prinet_sn_count
  vpc_id = aws_vpc.testvpc.id
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = random_shuffle.az.result[count.index]
  tags = {
    Name = "private-subnet-${count.index +1}"
  }
}
