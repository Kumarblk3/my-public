provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "practice_ec2" {
  ami           = "ami-0ffa797f35095b9f7"   # Amazon Linux 2 AMI for ap-south-1
  instance_type = "t3.micro"
  key_name = var.aws_keypair


  tags = {
    Name = "PracticeEC2"
  }
}
resource "aws_s3_bucket" "my-bucket" {
  bucket = "my-fist-s3-bucket-21"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "aws_keypair" {
  default = "my-kp-s3c"
}