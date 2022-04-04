provider "aws" {
  access_key = "Your AWS account's access_key provided by credentials_aws.csv"
  secret_key = "Your AWS account's secret_key provided by credentials_aws.csv"
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
