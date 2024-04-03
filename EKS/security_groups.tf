resource "aws_security_group" "terraform_eks_sg" {
  name   = "terraform_eks_sg"
  vpc_id = aws_vpc.terraform_eks_vpc.id
}

resource "aws_security_group_rule" "eks_sg_in_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_eks_sg.id
}
resource "aws_security_group_rule" "eks_sg_in_http" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_eks_sg.id
}
resource "aws_security_group_rule" "eks_sg_in_5001" {
  type              = "ingress"
  to_port           = 5001
  from_port         = 5001
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_eks_sg.id
}
resource "aws_security_group_rule" "eks_sg_out_http" {
  type              = "egress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_eks_sg.id
}
resource "aws_security_group_rule" "eks_sg_out_https" {
  type              = "egress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform_eks_sg.id
}


# resource "aws_security_group" "terraform_lb_sg" {
#   name   = "terraform_lb_sg"
#   vpc_id = aws_vpc.terraform_eks_vpc.id
# }

# resource "aws_security_group_rule" "lb_sg_in_5001" {
#   type              = "ingress"
#   to_port           = 5001
#   from_port         = 5001
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.terraform_lb_sg.id
# }
# resource "aws_security_group_rule" "lb_sg_in_https" {
#   type              = "ingress"
#   to_port           = 443
#   from_port         = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.terraform_lb_sg.id
# }
# resource "aws_security_group_rule" "lb_sg_in_http" {
#   type              = "ingress"
#   to_port           = 80
#   from_port         = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.terraform_lb_sg.id
# }
# resource "aws_security_group_rule" "lb_sg_out_http" {
#   type              = "egress"
#   to_port           = 80
#   from_port         = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.terraform_lb_sg.id
# }
# resource "aws_security_group_rule" "lb_sg_out_https" {
#   type              = "egress"
#   to_port           = 443
#   from_port         = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.terraform_lb_sg.id
# }