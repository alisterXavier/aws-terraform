resource "aws_lb" "terraform_lb" {
  name               = "terra-lb"
  internal           = false
  # load_balancer_type = "network"
  security_groups    = [aws_security_group.aws_lb_sg.id]
  subnets            = [aws_subnet.sub-1.id, aws_subnet.sub-2.id]
  tags = {
    Name = "terraform-lb"
  }
}

resource "aws_lb_listener" "terraform_lb_listner" {
  load_balancer_arn = aws_lb.terraform_lb.id
  port              = 5001
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform_lb_target_group.arn
  }
  depends_on = [aws_lb.terraform_lb]
}

resource "aws_lb_target_group" "terraform_lb_target_group" {
  name        = "ecs-target"
  port        = 5001
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.Terrform.id
}