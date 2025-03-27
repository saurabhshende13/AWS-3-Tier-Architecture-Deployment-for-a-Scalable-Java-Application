# modules/rds/main.tf

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids  # Subnets from both AZs
  
  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

resource "aws_iam_role" "rds_monitoring" {
  name               = "rds-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "rds.amazonaws.com",
            "monitoring.rds.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


resource "aws_kms_key" "db" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_db_instance" "main" {
  identifier              = "${var.environment}-db"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp3"
  
  db_name                = var.db_name
  username              = var.db_username
  password              = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  multi_az               = true
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.db.arn
  
  monitoring_interval    = 60
  monitoring_role_arn    = aws_iam_role.rds_monitoring.arn

  performance_insights_enabled = true
  auto_minor_version_upgrade   = true
  deletion_protection          = true

  tags = {
    Name = "${var.environment}-db"
  }
}

# # Add read replicas for read scaling
# resource "aws_db_instance" "read_replica" {
#   count               = 2  # One in each AZ
#   identifier          = "${var.environment}-db-read-${count.index + 1}"
#   instance_class      = var.db_instance_class
#   replicate_source_db = aws_db_instance.main.identifier
  
#   availability_zone   = var.availability_zones[count.index]
#   vpc_security_group_ids = [var.security_group_id]
  
#   # Enable encryption
#   storage_encrypted      = true
#   kms_key_id            = aws_kms_key.db.arn
  
#   # Enable monitoring
#   monitoring_interval    = 60
#   monitoring_role_arn    = aws_iam_role.rds_monitoring.arn
  
#   tags = {
#     Name = "${var.environment}-db-read-${count.index + 1}"
#   }
# }