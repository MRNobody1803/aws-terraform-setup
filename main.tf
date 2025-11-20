# ---- AWS PROVIDER ------------
provider "aws" {
  region = "us-east-1"
}

# ------- VPC ----------------------

resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

# --------  MODULES -----------------------

module "app-network" {
  source                = "./modules/network"

  avail_zone            = var.avail_zone
  env_prefix            = var.env_prefix
  vpc_id                = aws_vpc.app-vpc.id
  default_root_table_id = aws_vpc.app-vpc.default_route_table_id
  subnet_cidr_block     = var.subnet_cidr_block
}

module "app-webserver" {
  source               = "./modules/webserver"

  allowed_ip           = var.allowed_ip
  avail_zone           = var.avail_zone
  env_prefix           = var.env_prefix
  instance_type        = var.instance_type
  net-subnet           = module.app-network.subnet
  private_key_location = var.private_key_location
  public_key_location  = var.public_key_location
  vpc_id               = aws_vpc.app-vpc.id
  image_name           = var.image_name

}