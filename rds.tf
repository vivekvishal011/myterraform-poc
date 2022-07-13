resource "aws_db_subnet_group" "vishal" {
  name       = "public_subnet1"

  subnet_ids = [
    aws_subnet.pub_sub1.id,
    aws_subnet.pub_sub2.id
  ]

  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "vishal" {
  allocated_storage    = 100
  db_subnet_group_name = aws_db_subnet_group.vishal.name
  #db_subnet_group_name = "vishal"
  engine               = "postgres"
  engine_version       = "11.16"
  identifier           = "vishal-test"
  instance_class       = "db.m5.large"
  password             = "password"
  skip_final_snapshot  = true
  storage_encrypted    = true
  username             = "postgres"
  #db_subnet_group_name = aws_db_subnet_group.vishal.name
}
