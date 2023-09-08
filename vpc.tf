# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

  tags = {
     Name = "${var.project}-vpc"
  }
}

# Create a public subnet1 
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.project}-public-subnet-1"
  }
}

# Create a public subnet2 
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.project}-public-subnet-2"
  }
}

# Create a public subnet3
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${var.project}-public-subnet-3"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# Create route table 
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id

      }

    tags = {
        Name = "${var.project}-rt"
    }  
}

resource "aws_route_table_association" "public_subnet1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_subnet2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public_subnet3" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.main.id
}

# Create a private subnet1 
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.128.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.project}-private-subnet1"
  }
}
# Create a private subnet2 
resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.144.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.project}-private-subnet2"
  }
}

# Create a private subnet3 
resource "aws_subnet" "private-subnet-3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.160.0/20"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${var.project}-private-subnet3"
  }
}

# Create elastic IP
resource "aws_eip" "NAT-eip" {
  vpc = true

  tags = {
    Name = "${var.project}-NAT-eip"
  }
}

# Create NAT for private subnet

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.NAT-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "${var.project}-NAT-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
 depends_on = [aws_internet_gateway.gw]
}


# #Create route table for private subnet1
resource "aws_route_table" "rtb1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id

      }

    tags = {
        Name = "${var.project}-rtb1"
    }  
}

# Create route table for private subnet2
resource "aws_route_table" "rtb2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id

      }

    tags = {
        Name = "${var.project}-rtb2"
    }  
}

# Create route table for private subnet3
resource "aws_route_table" "rtb3" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id

      }

    tags = {
        Name = "${var.project}-rtb3"
    }  
}

resource "aws_route_table_association" "private_subnet1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.rtb1.id
}

resource "aws_route_table_association" "private_subnet2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.rtb2.id
}

resource "aws_route_table_association" "private_subnet3" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.rtb3.id
}




