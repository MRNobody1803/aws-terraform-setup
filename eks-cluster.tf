# provider "kubernetes" {
#   load_config_file = false
#   host = data.aws_eks_cluster.myapp-cluster.endpoint
#   token = data.aws_eks_cluster_auth.myapp-cluster.token
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
# }
#
# data "aws_eks_cluster" "myapp-cluster" {
#   name = module.eks.cluster_id
# }
#
# data "aws_eks_cluster_auth" "myapp-cluster" {
#   name = module.eks.cluster_id
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.10.1"

  name = "myapp-eks-cluster"
  vpc_id     = module.myapp-vpc.vpc_id
  subnet_ids = module.myapp-vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.micro"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3

      kubernetes_version = "1.27"
    }
  }

  tags = {
    environment = "development"
    application = "myapp"
  }
}
