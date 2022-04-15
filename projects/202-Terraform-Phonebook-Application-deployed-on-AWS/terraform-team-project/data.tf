data "aws_vpc" "main_vpc" {
  id = "vpc-065740f91024a5ae2"
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# data "aws_subnet" "defaultsubnets" {
#   vpc_id = "vpc-065740f91024a5ae2"

# }