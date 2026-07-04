provider "aws" {
  region = "ap-south-1"
}

# -------------------------------
# VPC + Subnet + IGW + Route Table
# -------------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "subnet_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# -------------------------------
# Transit Gateway + Attachment
# -------------------------------
resource "aws_ec2_transit_gateway" "tgw" {
  description = "My Transit Gateway"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.main.id
  subnet_ids         = [aws_subnet.main.id]
}

# Add TGW route into VPC route table
resource "aws_route" "tgw_route" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "192.168.0.0/16"   # Example remote network
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

# -------------------------------
# Security Group
# -------------------------------
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
  name   = "ec2-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------
# EC2 Instance
# -------------------------------
resource "aws_instance" "example" {
  ami           = "ami-0c1a7f89451184c8b" # Replace with valid AMI in ap-south-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "my-kp-demo1"

  tags = {
    Name = "DemoInstance"
  }
}