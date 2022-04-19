# Please change the key_name and your config file 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "instance-type" {
  default   = "t2.micro"
  sensitive = true
}

data "aws_security_group" "allow_ssh" {
  id = "sg-08b39f00f999db381"
}

resource "aws_instance" "tf-ec2" {
  ami                    = "ami-087c17d1fe0178315"
  instance_type          = var.instance-type
  key_name               = "mk"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  #  iam_instance_profile = "terraform"
  tags = {
    Name = "Docker-engine"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              newgrp docker
              # install docker-compose
              curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
              -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
	            EOF
}
output "myec2-public-ip" {
  value = aws_instance.tf-ec2.public_ip
}