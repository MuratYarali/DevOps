resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  key_name      = var.keyname
  tags = {
    "Name" = "${local.mytag}-come from locals"
  }
}

resource "aws_s3_bucket" "tf-s3" {
  # bucket = "${var.s3_bucket_name}-${count.index}"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 3
  for_each = toset(var.users)
  bucket   = "example-tf-s3-${each.value}"
}

resource "aws_iam_user" "new_user" {
  for_each = toset(var.users)
  name     = each.value
}