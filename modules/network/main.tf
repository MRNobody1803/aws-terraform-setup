# ----------- SUBNET ( WE WILL CREATE AFTER PRIVATE AND PUB ONE ) -------
resource "aws_subnet" "app-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}
# -------- INTERNET GATEWAY --------------
resource "aws_internet_gateway" "app-igw" {
  vpc_id = var.vpc_id
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
resource "aws_route_table_association" "ass-rtb-network" {
  route_table_id = aws_route_table.app-route-table.id
  subnet_id = aws_subnet.app-network-1.id
}*/

# ---- DEFAULT ROUTE TABLE ASS ------------------
resource "aws_default_route_table" "app-df-route-table" {
  default_route_table_id = var.default_root_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-df-rtb"
  }
}
# No needs to the association in this case when using default rtb
# because network is automaticaly associated with the default rtb



