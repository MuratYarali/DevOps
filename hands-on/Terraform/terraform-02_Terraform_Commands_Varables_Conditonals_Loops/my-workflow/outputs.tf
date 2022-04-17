output "tf-example-public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "tf_example_private_ip" {
  value = aws_instance.tf-ec2.private_ip
}

# output "tf-example-s3" {
#   value = aws_s3_bucket.tf-s3[*]
# }

output "uppercase_users" {
  value = [for user in var.users : upper(user) if length(user) > 6]
}