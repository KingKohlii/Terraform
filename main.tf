provider "aws" {
  region     = "ap-south-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "myvpc" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "public_subs" {
  count                   = 2
  cidr_block              = var.pubsub_cidr[count.index]
  vpc_id                  = aws_vpc.myvpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  tags = {
    Name = "public_subnet_${count.index + 1}"
  }

}


resource "aws_subnet" "private_subs" {
  count             = 4
  cidr_block        = var.pvtsub_cidr[count.index]
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % 2]

  tags = {
    Name = "private_subnet_${count.index + 1}"

  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myvpcigw"

  }
}

resource "aws_route_table" "public_route" {

  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "myvpc_public_route_table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = 2
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subs[count.index].id
}



resource "aws_route_table_association" "pvt_table_assoc" {
  count          = 4
  route_table_id = aws_vpc.myvpc.main_route_table_id
  subnet_id      = aws_subnet.private_subs[count.index].id
}

