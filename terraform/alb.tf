# =================================
# --- Application Load Balancer ---
# =================================
resource "aws_lb" "devinfra" {
  name               = "alb-ec1-devinfra"
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.ec1_lab.id]
  subnets = [
    data.aws_subnet.public_1a.id,
    data.aws_subnet.public_1b.id
  ]
  internal = false

  tags = {
    Name = "alb-ec1-devinfra"
  }
}
# ====================
# --- Target Group ---
# ====================
# A target group for forwarding HTTP traffic to our EC2 instance.
resource "aws_lb_target_group" "devinfra" {
  name        = "tg-ec1-devinfra"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = data.aws_vpc.ec1_lab.id
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    port     = "80"
    path     = "/"
  }

  tags = {
    Name = "tg-ec1-devinfra"
  }
}

# HTTP and HTTPS listeners for the ALB

# ===========================
# --- ALB listener (HTTP) ---
# ===========================
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.devinfra.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devinfra.arn
  }
}

# ============================
# --- ALB listener (HTTPS) ---
# ============================
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.devinfra.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.devops_ninja.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devinfra.arn
  }
}

# ===================================
# --- Attach: EC2 -> Target Group ---
# ===================================
# Attach the instance to the target group
resource "aws_lb_target_group_attachment" "devinfra_worker" {
  target_group_arn = aws_lb_target_group.devinfra.arn
  target_id        = aws_instance.devinfra_worker.id
  port             = 80
}
