terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.9.0"
    }
  }

  backend "s3" {
    bucket = "aws-web-3-tier-app-remote-backend"
    key = "terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "remote_backend_table"
    use_lockfile   = true
    
  }
}