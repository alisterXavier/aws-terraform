resource "aws_vpc" "Terrform" {
  cidr_block       = "10.0.0.0/20"
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Terrform.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "sub-1" {
  vpc_id     = aws_vpc.Terrform.id
  cidr_block = "10.0.0.0/21"
  availability_zone = "us-east-1a" 
  map_public_ip_on_launch = true
  tags = {
    Name = "sub-1"
  }
}

resource "aws_subnet" "sub-2" {
  vpc_id     = aws_vpc.Terrform.id
  cidr_block = "10.0.8.0/21"
  availability_zone = "us-east-1b" 
  map_public_ip_on_launch = true
  tags = {
    Name = "sub-2"
  }
}

resource "aws_route_table" "terraform_RT" {
  vpc_id = aws_vpc.Terrform.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
}

resource "aws_route_table_association" "route_table_association_sub_a" {
  route_table_id = aws_route_table.terraform_RT.id
  subnet_id = aws_subnet.sub-1.id
}
resource "aws_route_table_association" "route_table_association_sub_b" {
  route_table_id = aws_route_table.terraform_RT.id
  subnet_id = aws_subnet.sub-2.id
}