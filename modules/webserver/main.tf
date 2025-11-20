# ----------------- FIREWALL RULES -----------------------

resource "aws_default_security_group" "app-sg" {
  vpc_id = var.vpc_id
  # INBOUND TRAFFIC
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ALLOW ANY TRAFFIC TO LEAVE THE VPC (OUTBOUND TRAFFIC)
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name: "${var.env_prefix}-default-sg"
  }
}

# ------------------------------------------------------------
data "aws_ami" "lts-linux-img" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "app-server" {
  ami = data.aws_ami.lts-linux-img.id
  instance_type = var.instance_type

  subnet_id = var.net-subnet.id
  vpc_security_group_ids = [aws_default_security_group.app-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true # to be available from internet
  key_name = aws_key_pair.ssh-key.key_name

  #   user_data = file("entry-script.sh")

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.private_key_location)

  }

  ## PROVISIONNER ARE NOT RECOMMENDED IN TERRAFORM :(

  #   provisioner "file" {
  #     source = "entry-script.sh"
  #     destination = "/home/ec2-user/entry-script-ec2.sh"
  #   }
  #
  #   provisioner "remote-exec" {
  #     script = file("entry-script-ec2.sh")
  #   }

  #   provisioner "remote-exec" {
  #     inline = [
  #         "export ENV=dev",
  #         "mkdir newdir"
  #     ]
  #   }

  tags = {
    Name: "${var.env_prefix}-server"
  }

}

