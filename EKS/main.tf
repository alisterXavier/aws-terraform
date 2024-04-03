terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.terraform_eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.terraform_eks_cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.terraform_eks_cluster.id]
      command     = "aws"
    }
  }
}