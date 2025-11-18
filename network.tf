resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}
# ----------- SUBNET ( WE WILL CREATE AFTER PRIVATE AND PUB ONE ) -------
resource "aws_subnet" "app-subnet-1" {
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}
# -------- INTERNET GATEWAY --------------
resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}
# -------- ROUTE TABLE -----------------------
/*resource "aws_route_table" "app-route-table" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}
# --- ROUTE TABLE AND SUBNET ASS ---------------
resource "aws_route_table_association" "ass-rtb-subnet" {
  route_table_id = aws_route_table.app-route-table.id
  subnet_id = aws_subnet.app-subnet-1.id
}*/
# ---- DEFAULT ROUTE TABLE ASS ------------------
resource "aws_default_route_table" "app-df-route-table" {
  default_route_table_id = aws_vpc.app-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-df-rtb"
  }
}
# No needs to the association in this case when using default rtb
# because subnet is automaticaly associated with the default rtb

# ----------------- FIREWALL RULES -----------------------

resource "aws_default_security_group" "app-sg" {
  vpc_id = aws_vpc.app-vpc.id
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

