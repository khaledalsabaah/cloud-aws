variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "us_availability_zone" {}
variable "cidr_private_subnet" {}

output "vpc_1_id" {
  value = aws_vpc.vpc_1_us_east_1.id
}

output "public_subnets_1" {
  value = aws_subnet.public_subnets_1.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.public_subnets_1.*.cidr_block
}

# Setup VPC
resource "aws_vpc" "vpc_1_us_east_1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Setup public subnet
resource "aws_subnet" "public_subnets_1" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.vpc_1_us_east_1.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.us_availability_zone, count.index)

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Setup private subnet
resource "aws_subnet" "private_subnets_1" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.vpc_1_us_east_1.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.us_availability_zone, count.index)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "public_internet_gateway_1" {
  vpc_id = aws_vpc.vpc_1_us_east_1.id
  tags = {
    Name = "internet-gateway-1"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table_1" {
  vpc_id = aws_vpc.vpc_1_us_east_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway_1.id
  }
  tags = {
    Name = "public-route-table-1"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "public_rt_subnet_association_1" {
  count          = length(aws_subnet.public_subnets_1)
  subnet_id      = aws_subnet.public_subnets_1[count.index].id
  route_table_id = aws_route_table.public_route_table_1.id
}

# Private Route Table
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.vpc_1_us_east_1.id
  #depends_on = [aws_nat_gateway.nat_gateway]
  tags = {
    Name = "private-route-table-1"
  }
}

# Private Route Table and private Subnet Association
resource "aws_route_table_association" "private_rt_subnet_association_1" {
  count          = length(aws_subnet.private_subnets_1)
  subnet_id      = aws_subnet.private_subnets_1[count.index].id
  route_table_id = aws_route_table.private_route_table_1.id
}
