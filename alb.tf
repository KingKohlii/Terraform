resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subs[*].id
  security_groups    = ["aws_security_group.albsg.id"]

}

resource "aws_security_group" "albsg" {
  vpc_id = aws_vpc.myvpc.id

}

resource "aws_security_group_rule" "alb_in_rule" {
  protocol          = "tcp"
  security_group_id = aws_security_group.albsg.id
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"

}

resource "aws_security_group_rule" "alb_out_rule" {
  protocol          = "-1"
  security_group_id = aws_security_group.albsg.id
  from_port         = "0"
  to_port           = "0"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"

}

resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }
}






