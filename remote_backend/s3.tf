resource "aws_s3_bucket" "my_bucket" {
    bucket = "aws-web-3-tier-app-remote-backend"
    
    tags ={
        Name = "AWS Bucket"
    }

  
}

resource "aws_dynamodb_table" "dynamodb" {
  name = "remote_backend_table"
  billing_mode   = "PAY_PER_REQUEST"
 
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
 tags = {
    Name        = "Remote-Backend"
    Environment = "Remote-Bckend"
  }

}