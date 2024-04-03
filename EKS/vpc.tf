resource "aws_vpc" "terraform_eks_vpc" {
  cidr_block       = "10.0.0.0/20"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "terraform_eks_vpc_igw" {
  vpc_id = aws_vpc.terraform_eks_vpc.id
}
resource "aws_eip" "terraform_Nat" {
  tags = {
    Name = "Nat"
  }
}
resource "aws_nat_gateway" "terraform_eks_Nat" {
  subnet_id     = aws_subnet.terraform_eks_vpc_public_subnet[1].id
  allocation_id = aws_eip.terraform_Nat.id
  
}

resource "aws_subnet" "terraform_eks_vpc_public_subnet" {
  count                   = length(var.pub_subnets)
  vpc_id                  = aws_vpc.terraform_eks_vpc.id
  availability_zone       = element(var.pub_subnets[*].az, count.index)
  cidr_block              = element(var.pub_subnets[*].ip, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name                                        = format("terraform-subnet-%s", var.subnets[count.index].az)
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
resource "aws_subnet" "terraform_eks_vpc_private_subnets" {
  count             = length(var.subnets)
  vpc_id            = aws_vpc.terraform_eks_vpc.id
  cidr_block        = element(var.subnets[*].ip, count.index)
  availability_zone = element(var.subnets[*].az, count.index)

  tags = {
    Name                                        = format("terraform-subnet-%s", var.subnets[count.index].az)
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_route_table" "terraform_eks_vpc_public_RT" {
  vpc_id = aws_vpc.terraform_eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_eks_vpc_igw.id
  }
  tags = {
    Name = "terraform_eks_vpc_RT"
  }
}
resource "aws_route_table" "terraform_eks_vpc_private_RT" {
  vpc_id = aws_vpc.terraform_eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_eks_Nat.id
  }
  tags = {
    Name = "terraform_eks_vpc_private_RT"
  }
}

resource "aws_route_table_association" "terraform_eks_vpc_RT_public_association" {
  count          = length(var.subnets)
  route_table_id = aws_route_table.terraform_eks_vpc_public_RT.id
  subnet_id      = element(aws_subnet.terraform_eks_vpc_public_subnet[*].id, count.index)
}
resource "aws_route_table_association" "terraform_eks_vpc_RT_private_association" {
  count          = length(var.subnets)
  route_table_id = aws_route_table.terraform_eks_vpc_private_RT.id
  subnet_id      = element(aws_subnet.terraform_eks_vpc_private_subnets[*].id, count.index)
}
