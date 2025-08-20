#key
resource "aws_key_pair" "my_key" {
    key_name = "3-tier-key"
    public_key = file("3-tier-key.pub")
  
}


#ec2

resource "aws_instance" "web_instance" {
  instance_type = var.instance_type
  security_groups = ["aws_security_group.My_sg.name"]
  key_name = aws_key_pair.my_key.key_name
  ami = var.instance_ami
  user_data = file("app_code.sh")
  subnet_id = module.vpc.public_subnets[0]

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
  tags ={

    name = "${var.env}-Public_Instance"
    Environment = "${var.env}"
  }

}

resource "aws_instance" "app_instance" {
  instance_type = var.instance_type
  security_groups = ["aws_security_group.My_sg.name"]
  key_name = aws_key_pair.my_key.key_name
  ami = var.instance_ami
  user_data = file("app_code.sh")
  subnet_id = module.vpc.private_subnets[0]

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }
  tags ={

    name = "${var.env}-Private_Instance"
    Environment = "${var.env}"
  }

}