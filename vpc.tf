resource "aws_vpc" "Paycell-stage-VPC" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "Paycell-stage-VPC"
  }
}

resource "aws_subnet" "Paycell-stage-Public-Subnet-1" {
  cidr_block              = var.public_subnet_1_cidr_block
  vpc_id                  = aws_vpc.Paycell-stage-VPC.id
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Paycell-stage-Public-Subnet-1"
  }
}
resource "aws_subnet" "Paycell-stage-Public-Subnet-2" {
  cidr_block              = var.public_subnet_2_cidr_block
  vpc_id                  = aws_vpc.Paycell-stage-VPC.id
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Paycell-stage-Public-Subnet-2"
  }
}
resource "aws_subnet" "Paycell-stage-Public-Subnet-3" {
  cidr_block              = var.public_subnet_3_cidr_block
  vpc_id                  = aws_vpc.Paycell-stage-VPC.id
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "Paycell-stage-Public-Subnet-3"
  }
}

resource "aws_subnet" "Paycell-stage-Private-Subnet-1" {
  cidr_block              = var.private_subnet_1_cidr_block
  vpc_id                  = aws_vpc.Paycell-stage-VPC.id
  availability_zone       = "${var.region}a"
  tags = {
    Name = "Paycell-stage-Private-Subnet-1"
  }
}
resource "aws_subnet" "Paycell-stage-Private-Subnet-2" {
  cidr_block              = var.private_subnet_2_cidr_block
  vpc_id                  = aws_vpc.Paycell-stage-VPC.id
  availability_zone       = "${var.region}b"
  tags = {
    Name = "Paycell-stage-Private-Subnet-2"
  }
}
resource "aws_subnet" "Paycell-stage-Private-Subnet-3" {
  cidr_block              = var.private_subnet_3_cidr_block
  vpc_id                  = aws_vpc.Paycell-stage-VPC.id
  availability_zone       = "${var.region}c"
  tags = {
    Name = "Paycell-stage-Private-Subnet-3"
  }
}

resource "aws_route_table" "Paycell-stage-Public-Route-Table" {
  vpc_id = aws_vpc.Paycell-stage-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Paycell-stage-Internet-Gateway.id
  }
  tags = {
    Name = "Paycell-stage-Public-Route-Table"
  }
}
resource "aws_route_table" "Paycell-stage-Private-Route-Table" {
  vpc_id = aws_vpc.Paycell-stage-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Paycell-stage-Nat-Gateway.id
  }
  tags = {
    Name = "Paycell-stage-Private-Route-Table"
  }
}


resource "aws_internet_gateway" "Paycell-stage-Internet-Gateway" {
  vpc_id = aws_vpc.Paycell-stage-VPC.id
  tags = {
    Name = "Paycell-stage-Internet-Gateway"
  }
}
resource "aws_eip" "Paycell-stage-Elastic-Ip" {
  vpc = true
  tags = {
    Name = "Paycell-stage-Elastic-Ip"
  }
}
resource "aws_nat_gateway" "Paycell-stage-Nat-Gateway" {
  allocation_id = aws_eip.Paycell-stage-Elastic-Ip.id
  subnet_id     = aws_subnet.Paycell-stage-Public-Subnet-1.id
  tags = {
    Name = "Paycell-stage-Nat-Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Paycell-stage-Internet-Gateway]
}


resource "aws_route_table_association" "Public-Subnet-1" {
  subnet_id      = aws_subnet.Paycell-stage-Public-Subnet-1.id
  route_table_id = aws_route_table.Paycell-stage-Public-Route-Table.id
}
resource "aws_route_table_association" "Public-Subnet-2" {
  subnet_id      = aws_subnet.Paycell-stage-Public-Subnet-2.id
  route_table_id = aws_route_table.Paycell-stage-Public-Route-Table.id
}
resource "aws_route_table_association" "Public-Subnet-3" {
  subnet_id      = aws_subnet.Paycell-stage-Public-Subnet-3.id
  route_table_id = aws_route_table.Paycell-stage-Public-Route-Table.id
}
resource "aws_route_table_association" "Private-Subnet-1" {
  subnet_id      = aws_subnet.Paycell-stage-Private-Subnet-1.id
  route_table_id = aws_route_table.Paycell-stage-Private-Route-Table.id
}
resource "aws_route_table_association" "Private-Subnet-2" {
  subnet_id      = aws_subnet.Paycell-stage-Private-Subnet-2.id
  route_table_id = aws_route_table.Paycell-stage-Private-Route-Table.id
}
resource "aws_route_table_association" "Private-Subnet-3" {
  subnet_id      = aws_subnet.Paycell-stage-Private-Subnet-3.id
  route_table_id = aws_route_table.Paycell-stage-Private-Route-Table.id
}



