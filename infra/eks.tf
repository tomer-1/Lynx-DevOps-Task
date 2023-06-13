
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.3.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }

  }
}

# Specifying the AWS provider
provider "aws" {
  region = "us-west-2"  # Update with your desired AWS region
}

# Use the Helm provider
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

# Creating the VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.3.0"

  name                 = "my-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]  # Update with your desired availability zones
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # Update with your desired private subnets
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]  # Update with your desired public subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "production"
  }
}

# Creating the EKS cluster
module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"

  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  manage_aws_auth = true

  tags = {
    Environment = "production"
  }
}

# Deploy ingress controller to the cluster
resource "helm_release" "ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx/ingress-nginx"
  version    = "4.7.0"
}

# Deploy PostgreSQL to the cluster using the provided values file
resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "12.5.6"
  values = [
    "${file("../postgresql/values.yaml")}"
  ]
}
