provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-2a"
}

resource "aws_instance" "practice_ec2" {
  ami           = "ami-0ffa797f35095b9f7"   # Amazon Linux 2 AMI for ap-south-1
  instance_type = "t3.micro"
  key_name = var.aws_keypair
  subnet_id     = aws_subnet.my-subnet.id

  tags = {
    Name = "PracticeEC2"
  }
}

variable "aws_region" {
  default = "ap-south-2"
}

variable "aws_keypair" {
  default = "my-kp-s3c"
}