provider "aws" {
  access_key = "AKIA6CC6X4EOFAU3MXZI"
  secret_key = "5wmt7O+jjyisrKPuJkpwKC/FXZtrRsBEXt88Rlrs"
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
}
