resource "aws_security_group" "aws_lb_sg" {
  name        = "aws-lb-service-sg"
  description = "Rules for ecs service"
  vpc_id      = aws_vpc.Terrform.id
}
# resource "aws_security_group_rule" "sg_lb_service_https_ingress" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.aws_lb_sg.id
# }
# resource "aws_security_group_rule" "sg_lb_service_http_ingress" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.aws_lb_sg.id
# }
# resource "aws_security_group_rule" "sg_lb_service_https_egress" {
#   type              = "egress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.aws_lb_sg.id
# }

// ***
resource "aws_security_group_rule" "sg_lb_service_5001_ingress" {
  type              = "ingress"
  from_port         = 5001
  to_port           = 5001
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_lb_sg.id
}
resource "aws_security_group_rule" "sg_lb_service_5001_egress" {
  type              = "egress"
  from_port         = 5001
  to_port           = 5001
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_lb_sg.id
}
resource "aws_security_group_rule" "sg_lb_service_http_egress" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_lb_sg.id
}


resource "aws_security_group" "aws_ecs_service_sg" {
  name        = "aws-ecs-service-sg"
  description = "Rules for ecs service"
  vpc_id      = aws_vpc.Terrform.id
}
resource "aws_security_group_rule" "sg_ecs_service_http_ingress" {
  type                     = "ingress"
  from_port                = 5001
  to_port                  = 5001
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.aws_lb_sg.id
  security_group_id        = aws_security_group.aws_ecs_service_sg.id
}
# resource "aws_security_group_rule" "sg_ecs_service_http_egress" {
#   type              = "egress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.aws_ecs_service_sg.id
# }
resource "aws_security_group_rule" "sg_ecs_service_https_egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_ecs_service_sg.id
}
