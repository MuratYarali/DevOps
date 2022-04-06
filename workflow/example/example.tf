
provider "aws" {
  profile = "default"
  region  = "us-west-2"
}
resource "aws_key_pair" "example" {
  key_name   = "felix"
  public_key = file("~/.ssh/terraform.pub")
}
resource "aws_instance" "example" {
  key_name      = aws_key_pair.example.felix
  ami           = "ami-04590e7389a6e577c"
  instance_type = "t2.micro"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
]
}
}
