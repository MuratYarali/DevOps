provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}

variable "ec2_name" {
  default = "oliver-ec2"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-0742b4e673072066f"
}

resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  key_name      = "mk"
  tags = {
    Name = "${var.ec2_name}-instance"
  }
}

variable "s3_bucket_name" {
  default = "murat-s3-bucket-variable-addwhateveryouwant"
}

resource "aws_s3_bucket" "tf-s3" {
  bucket = var.s3_bucket_name
}

output "tf-example-public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}

output "tf-example-s3" {
  value = aws_s3_bucket.tf-s3[*]
}