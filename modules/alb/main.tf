##############################################################
# ALB Module
# Resources: Application Load Balancer, Target Group, Listener
##############################################################

# ── Application Load Balancer ────────────────────────────────
resource "aws_lb" "alb" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_sg_id]

  subnets = [
    var.public_subnet_1,
    var.public_subnet_2,
  ]

  tags = {
    Name = "${var.env}-ALB"
    Env  = var.env
  }
}

# ── Target Group ─────────────────────────────────────────────
resource "aws_lb_target_group" "tg" {
  name     = "${var.env}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name = "${var.env}-web-tg"
    Env  = var.env
  }
}

# ── HTTP Listener ─────────────────────────────────────────────
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
