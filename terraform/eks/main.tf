module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "Self-Hosted-Runner"
  cluster_version = "1.29"
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  eks_managed_node_groups = {
    default = {
      instance_types = ["t2.micro"]
      desired_size   = 1
      max_size       = 1
      min_size       = 1
    }
  }

  enable_irsa = true
}

