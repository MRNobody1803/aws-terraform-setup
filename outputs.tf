# AMI ID
output "aws_ami_id" {
  value = data.aws_ami.lts-linux-img.id
}
# Public IP of Ec2 instance
output "ec2_public_ip" {
  value = aws_instance.app-server.public_ip
}