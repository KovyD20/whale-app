resource "aws_lb" "main" {
  name               = "kd-whale-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id, aws_subnet.public_c.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "main" {
  name        = "kd-whale-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled  = true
    path     = "/health"
    matcher  = "200"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group_attachment" "server" {
  for_each = aws_instance.server

  target_group_arn = aws_lb_target_group.main.arn
  target_id        = each.value.id
  port             = 80
}
