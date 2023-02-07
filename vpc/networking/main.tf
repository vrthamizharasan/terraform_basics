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

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.testvpc.id 
}

resource "aws_route_table" "public_route" {
 vpc_id = aws_vpc.testvpc.id  
      route {
       cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_route" {
      vpc_id = aws_vpc.testvpc.id  
}

resource "aws_route_table_association" "public" {
    count = var.pubnet_sn_count
    route_table_id = aws_route_table.public_route.id 
    subnet_id = aws_subnet.public_subnet.*.id[count.index]
}

resource "aws_route_table_association" "private" {
    count = var.prinet_sn_count
    route_table_id = aws_route_table.private_route.id  
    subnet_id = aws_subnet.private_subnet.*.id[count.index]
}

