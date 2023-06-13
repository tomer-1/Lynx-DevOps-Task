terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  provider "aws" {
    region = var.region
  }

  module "eks" {
    source = "hashicorp/eks/aws"
    version = "~> 3.12.0"

    cluster_name = "eks-cluster"
    version = "1.19"
    node_groups {
      name = "default"
      desired_capacity = 3
      node_type = "t3.medium"
    }
  }

  output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
  }

  output "kubectl_config" {
    value = module.eks.kubectl_config
  }
}
