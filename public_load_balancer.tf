# ----------------------------------------
# Create Security Group for Load Balancer
# ----------------------------------------
resource "aws_security_group" "alb_sg3" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open to all, restrict if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ----------------------------------------
# Application Load Balancer
# ----------------------------------------


resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg3.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
}

# ----------------------------------------
# Target Group for ASG Instances
# ----------------------------------------
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# ----------------------------------------
# Listener for ALB
# ----------------------------------------
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# ----------------------------------------
# Attach Auto Scaling Groups to Target Group
# ----------------------------------------
resource "aws_autoscaling_attachment" "asg1_attach" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  lb_target_group_arn = aws_lb_target_group.app_tg.arn
}

resource "aws_autoscaling_attachment" "asg2_attach" {
  autoscaling_group_name = aws_autoscaling_group.web_asg2.id
  lb_target_group_arn = aws_lb_target_group.app_tg.arn
}
