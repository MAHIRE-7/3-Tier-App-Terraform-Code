# ----------------------------------------
# Create Security Group for Load Balancer
# ----------------------------------------
resource "aws_security_group" "alb_private_sg" {
  name        = "alb-private-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # open to all, restrict if needed
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


resource "aws_lb" "app_lb2" {
  name               = "app-private-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_private_sg.id]
  subnets            = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  enable_deletion_protection = false
}

# ----------------------------------------
# Target Group for ASG Instances
# ----------------------------------------
resource "aws_lb_target_group" "app_tg2" {
  name     = "app-private-tg"
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
resource "aws_lb_listener" "app_listener2" {
  load_balancer_arn = aws_lb.app_lb2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg2.arn
  }
}

# ----------------------------------------
# Attach Auto Scaling Groups to Target Group
# ----------------------------------------
resource "aws_autoscaling_attachment" "asg_attach1" {
  autoscaling_group_name = aws_autoscaling_group.web_private_asg.id
  lb_target_group_arn = aws_lb_target_group.app_tg2.arn
}

resource "aws_autoscaling_attachment" "asg_attach2" {
  autoscaling_group_name = aws_autoscaling_group.web_private_asg2.id
  lb_target_group_arn = aws_lb_target_group.app_tg2.arn
}
