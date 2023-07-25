resource "aws_vpc" "Eks-VPC" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.cluster_name}-VPC"
  }
}

resource "aws_subnet" "Public-Subnet-1" {
  cidr_block              = var.public_subnet_1_cidr_block
  vpc_id                  = aws_vpc.Eks-VPC.id
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-Public-Subnet-1"
  }
}
resource "aws_subnet" "Public-Subnet-2" {
  cidr_block              = var.public_subnet_2_cidr_block
  vpc_id                  = aws_vpc.Eks-VPC.id
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-Public-Subnet-2"
  }
}
resource "aws_subnet" "Public-Subnet-3" {
  cidr_block              = var.public_subnet_3_cidr_block
  vpc_id                  = aws_vpc.Eks-VPC.id
  availability_zone       = "${var.region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-Public-Subnet-3"
  }
}

resource "aws_subnet" "Private-Subnet-1" {
  cidr_block              = var.private_subnet_1_cidr_block
  vpc_id                  = aws_vpc.Eks-VPC.id
  availability_zone       = "${var.region}a"
  tags = {
    Name = "${var.cluster_name}-Private-Subnet-1"
  }
}
resource "aws_subnet" "Private-Subnet-2" {
  cidr_block              = var.private_subnet_2_cidr_block
  vpc_id                  = aws_vpc.Eks-VPC.id
  availability_zone       = "${var.region}b"
  tags = {
    Name = "${var.cluster_name}-Private-Subnet-2"
  }
}
resource "aws_subnet" "Private-Subnet-3" {
  cidr_block              = var.private_subnet_3_cidr_block
  vpc_id                  = aws_vpc.Eks-VPC.id
  availability_zone       = "${var.region}c"
  tags = {
    Name = "${var.cluster_name}-Private-Subnet-3"
  }
}

resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.Eks-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet-Gateway.id
  }
  tags = {
    Name = "${var.cluster_name}-Public-Route-Table"
  }
}
resource "aws_route_table" "Private-Route-Table" {
  vpc_id = aws_vpc.Eks-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Nat-Gateway.id
  }
  tags = {
    Name = "${var.cluster_name}-Private-Route-Table"
  }
}


resource "aws_internet_gateway" "Internet-Gateway" {
  vpc_id = aws_vpc.Eks-VPC.id
  tags = {
    Name = "${var.cluster_name}-Internet-Gateway"
  }
}
resource "aws_eip" "Elastic-Ip" {
  vpc = true
  tags = {
    Name = "${var.cluster_name}-Elastic-Ip"
  }
}
resource "aws_nat_gateway" "Nat-Gateway" {
  allocation_id = aws_eip.Elastic-Ip.id
  subnet_id     = aws_subnet.Public-Subnet-1.id
  tags = {
    Name = "${var.cluster_name}-Nat-Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Internet-Gateway]
}


resource "aws_route_table_association" "Public-Subnet-1" {
  subnet_id      = aws_subnet.Public-Subnet-1.id
  route_table_id = aws_route_table.Public-Route-Table.id
}
resource "aws_route_table_association" "Public-Subnet-2" {
  subnet_id      = aws_subnet.Public-Subnet-2.id
  route_table_id = aws_route_table.Public-Route-Table.id
}
resource "aws_route_table_association" "Public-Subnet-3" {
  subnet_id      = aws_subnet.Public-Subnet-3.id
  route_table_id = aws_route_table.Public-Route-Table.id
}
resource "aws_route_table_association" "Private-Subnet-1" {
  subnet_id      = aws_subnet.Private-Subnet-1.id
  route_table_id = aws_route_table.Private-Route-Table.id
}
resource "aws_route_table_association" "Private-Subnet-2" {
  subnet_id      = aws_subnet.Private-Subnet-2.id
  route_table_id = aws_route_table.Private-Route-Table.id
}
resource "aws_route_table_association" "Private-Subnet-3" {
  subnet_id      = aws_subnet.Private-Subnet-3.id
  route_table_id = aws_route_table.Private-Route-Table.id
}



