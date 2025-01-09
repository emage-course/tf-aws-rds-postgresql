################################################################################
# VPC
################################################################################

resource "aws_vpc" "rds_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "priv-subnet" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "rds-priv-subnet1"
  }
  map_public_ip_on_launch = false
}

resource "aws_subnet" "priv-subnet2" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "rds-priv-subnet2"
  }
  map_public_ip_on_launch = false
}

resource "aws_db_subnet_group" "subnet-group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.priv-subnet.id, aws_subnet.priv-subnet2.id]

  tags = {
    Name        = "dev-rds-subnet-group"
    Owner       = "Cloud Engineering"
    App         = "wordpress"
    Environment = "dev"
  }
}

