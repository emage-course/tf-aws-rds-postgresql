################################################################################
# AWS KMS encryption 
################################################################################
resource "aws_kms_key" "kms_key_us_east" {
  deletion_window_in_days = 30

  tags = {
    Name = "kms_key_us_east"
    Owner       = "Cloud Engineering"
    App         = "wordpress"
    Environment = "dev"
  }
}

################################################################################
# Master DB
################################################################################

resource "aws_db_instance" "primary-db" {
  identifier              = "wordpressdev"
  engine                  = "postgres"
  engine_version          = "17"
  instance_class          = "db.m5.xlarge"
  allocated_storage       = 30
  storage_type            = "gp3"
  port                    = 5432
  db_name                 = "postgres"
  username                = "postgres"
  password                = "postgres123"
  backup_retention_period = 7
  storage_encrypted       = true
  skip_final_snapshot     = true
  multi_az                = "true"
  apply_immediately       = "false"
  copy_tags_to_snapshot   = "true"
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:04:30"
  deletion_protection     = "true"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet-group.name
  kms_key_id             = aws_kms_key.kms_key_us_east.arn
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
  performance_insights_enabled = "true"

  tags = {
    Name        = "primary-wordpressdev"
    Owner       = "Cloud Engineering"
    App         = "wordpress"
    Environment = "dev"
  }
}

################################################################################
# aws_kms_key
################################################################################

resource "aws_kms_key" "kms_key_us_west" {
  deletion_window_in_days = 30

  tags = {
    Name = "kms_key_us_west"
    Owner       = "Cloud Engineering"
    App         = "wordpress"
    Environment = "dev"
  }

  provider = aws.replica
}

################################################################################
# Cross-region replicas
################################################################################

# resource "aws_db_instance" "replica-db" {
#   provider                = aws.replica
#   availability_zone       = "us-west-1a"
#   identifier              = "wordpressdev-replica"
#   replicate_source_db     = aws_db_instance.primary-db.identifier
#   engine                  = "postgres"
#   engine_version          = "16"
#   instance_class          = "db.m5.xlarge"
#   storage_type            = "gp3"
#   port                    = 5432
#   backup_retention_period = 7
#   storage_encrypted       = "true"
#   skip_final_snapshot     = "true"
#   apply_immediately       = "false"
#   backup_window           = "03:00-04:00"
#   maintenance_window      = "mon:04:00-mon:04:30"
#   copy_tags_to_snapshot   = "true"
#   deletion_protection     = "true"
#   kms_key_id              = aws_kms_key.kms_key_us_east.arn
#   monitoring_interval          = 60
#   monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
#   performance_insights_enabled = "true"
#   depends_on                   = [aws_db_instance.primary-db]
#   tags = {
#     Name        = "secondary-wordpressdev"
#     Owner       = "Cloud Engineering"
#     App         = "wordpress"
#     Environment = "dev"
#   }
# }

################################################################################
#  Cross-region replicas
################################################################################

resource "aws_db_instance_automated_backups_replication" "cross-region-replica" {
  source_db_instance_arn = aws_db_instance.primary-db.arn
  retention_period       = 7
  kms_key_id             = aws_kms_key.kms_key_us_west.arn
  provider               = aws.replica
}

