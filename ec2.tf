data "aws_ami" "lts-linux-img" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.lts-linux-img.id
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "app-server" {
  ami = data.aws_ami.lts-linux-img.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.app-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.app-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true # to be available from internet
  key_name = aws_key_pair.ssh-key.key_name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y && sudo yum install -y docker
    sudo systemctl start docker
    sudo usermod -aG docker ec2-user
    docker run -p 8080:80 nginx
  EOF

  tags = {
    Name: "${var.env_prefix}-server"
  }

}