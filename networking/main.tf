data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 5
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "yap_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "yap_vpc_${random_integer.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "yap_public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.yap_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    "Name" = "yap_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "yap_public_association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.yap_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.yap_public_rt.id
}

resource "aws_subnet" "yap_private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.yap_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    "Name" = "yap_private_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "yap_igw" {
  vpc_id = aws_vpc.yap_vpc.id

  tags = {
    "Name" = "yap_igw"
  }
}

resource "aws_route_table" "yap_public_rt" {
  vpc_id = aws_vpc.yap_vpc.id

  tags = {
    "Name" = "yap_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.yap_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.yap_igw.id
}

resource "aws_default_route_table" "yap_private_rt" {
  default_route_table_id = aws_vpc.yap_vpc.default_route_table_id

  tags = {
    "Name" = "yap_private"
  }
}

resource "aws_security_group" "yap_sg" {
  name        = "public_sg"
  description = "Security group for public access"
  vpc_id      = aws_vpc.yap_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}