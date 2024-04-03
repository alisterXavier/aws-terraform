resource "aws_eks_cluster" "terraform_eks_cluster" {
  name     = "terraform-eks-cluster"
  role_arn = aws_iam_role.terraform_eks_role_policy.arn
  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = aws_subnet.terraform_eks_vpc_private_subnets[*].id
    # security_group_ids      = [aws_security_group.terraform_eks_sg.id]
  }

}

# resource "aws_eks_fargate_profile" "terraform_eks_fargate_profile_kube_system" {
#   fargate_profile_name   = "kube-system"
#   cluster_name           = aws_eks_cluster.terraform_eks_cluster.name
#   pod_execution_role_arn = aws_iam_role.terraform_eks_fargate_pods.arn
#   subnet_ids             = aws_subnet.terraform_eks_vpc_private_subnets[*].id
#   selector {
#     namespace = "kube-system"
#   }
# }

resource "aws_eks_fargate_profile" "terraform_eks_fargate_profile_pao" {
  fargate_profile_name   = "pao"
  cluster_name           = aws_eks_cluster.terraform_eks_cluster.name
  pod_execution_role_arn = aws_iam_role.terraform_eks_fargate_pods.arn
  subnet_ids             = aws_subnet.terraform_eks_vpc_private_subnets[*].id
  selector {
    namespace = "pao"
  }
}

resource "aws_eks_node_group" "terraform_eks_node_group" {
  cluster_name    = aws_eks_cluster.terraform_eks_cluster.name
  node_group_name = "terraform_eks_node_group"
  node_role_arn   = aws_iam_role.aws_eks_node_role.arn
  subnet_ids      = aws_subnet.terraform_eks_vpc_private_subnets[*].id
  scaling_config {

    min_size     = 1
    desired_size = 2
    max_size     = 50
  }

  ami_type       = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
  capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
  disk_size      = 20
  instance_types = ["m5.large"]
  update_config {
    max_unavailable = 1
  }

  labels = {
    node-type = "ec2"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSNodePolicy,
    aws_iam_role_policy_attachment.AmazonCNIPolicy,
    aws_iam_role_policy_attachment.AmazonEKSContainerRegistery,
  ]
}