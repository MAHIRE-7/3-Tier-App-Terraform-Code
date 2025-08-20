module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-VPC"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.9.0/24" ]
  public_subnets  = ["10.0.105.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}