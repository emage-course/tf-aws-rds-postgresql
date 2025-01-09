################################################################################
# SG
################################################################################
# Default VPC

resource "aws_security_group" "rds-sg" {
  name        = "rds-security-group"
  description = "dev-rds-sg"
  vpc_id      = aws_vpc.rds_vpc.id

  ingress {
    description = "dev-rds-sg"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "dev-rds-sg"
    Owner       = "Cloud Engineering"
    App         = "wordpress"
    Environment = "dev"
  }
}
