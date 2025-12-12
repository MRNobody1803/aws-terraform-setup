provider "aws" {
  region = "us-east-1"
}


module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "Kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "Kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "Kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "Kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "Kubernetes.io/role/internal-elb" = 1
  }

}

data "aws_availability_zones" "azs" {}