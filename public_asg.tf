
#securitygroup
resource "aws_security_group" "My_sg" {
    name = "${var.env}-Sg"
    vpc_id = module.vpc.vpc_id
    description = "${var.env} Security group"
    
    ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "This is fo SSH Traffic"
    protocol    = "tcp"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "This is for Https Traffic"
    protocol    = "tcp"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "This is for Http Traffic"
    protocol    = "tcp"
  }

  egress  {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "This is for All Outbond traffic allow Traffic"
    protocol    = -1

  }

  tags = {
    Environment = "${var.env}"
  }

} 

resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.env}-web-lt"
  image_id      = var.instance_ami       # Replace with your AMI (e.g., Amazon Linux 2)
  instance_type = var.instance_type
  user_data = file("public_app.sh")

  key_name = file("3-tier-key")                 # Replace with your key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.My_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-instance"
    }
  }
}




resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1

  vpc_zone_identifier  = [module.vpc.public_subnets[0] ]  # attach ASG to your public subnets

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}

# ASG in public subnets  AZs 2


resource "aws_autoscaling_group" "web_asg2" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1

  vpc_zone_identifier  = [module.vpc.public_subnets[1]]  # attach ASG to your public subnets

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-asg-instance2"
    propagate_at_launch = true
  }
}
