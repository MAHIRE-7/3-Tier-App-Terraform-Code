
resource "aws_db_subnet_group" "mydb_subnet" {
  name       = "mydb-subnet-group"
  subnet_ids = [module.vpc.private_subnets[2], module.vpc.private_subnets[3]] # Use subnets in different AZs

  tags = {
    Name = "mydb-subnet-group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  username             = "root"
  password             = null
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
    db_subnet_group_name   = aws_db_subnet_group.mydb_subnet.name
}
