resource "aws_db_subnet_group" "rds_db_subgroup" {
  name       = var.RDS_SUBNET_GROUP_NAME
  subnet_ids = module.cluster.private_subnet_ids
}


resource "aws_security_group" "sg_rds" {
  name = "rds_sg"
  vpc_id      = module.cluster.vpc_id

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = map(
    "Name", format("%s", var.NAME),
    "owner", var.EKS_OWNER_TAG,
    "project", var.EKS_PROJECT_TAG,
  )
}

resource aws_security_group_rule sg_rds_1 {

  depends_on = [aws_security_group.sg_rds]
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Permit rule"
  from_port         = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_rds.id
  to_port           = 5432
  type              = "ingress"
}

resource "aws_db_instance" "rds_db" {
  identifier = var.RDS_IDENTIFIER

  allocated_storage       = var.RDS_ALLOCATED_STORAGE
  backup_retention_period = var.RDS_BACKUP_RETENTION_PERIOD
  backup_window           = var.RDS_BACKUP_WINDOW
  engine                  = var.RDS_ENGINE
  engine_version          = var.RDS_ENGINE_VERSION
  instance_class          = var.RDS_INSTANCE_CLASS
  multi_az                = var.RDS_MULTI_AZ
  name                    = var.RDS_DB_NAME
  username                = var.RDS_USERNAME
  password                = var.RDS_PASSWORD
  port                    = var.RDS_PORT
  publicly_accessible     = var.RDS_PUBLICLY_ACCESSIBLE
  storage_encrypted       = var.RDS_STORAGE_ENCRYPTED
  storage_type            = var.RDS_STORAGE_TYPE
  deletion_protection     = var.RDS_DELETION_PROTECTION

  vpc_security_group_ids  = [aws_security_group.sg_rds.id]

  allow_major_version_upgrade = var.RDS_ALLOW_MAJOR_VERSION_UPGRADE
  auto_minor_version_upgrade  = var.RDS_AUTO_MINOR_VERSION_UPGRADE

  skip_final_snapshot       = var.RDS_SKIP_FINAL_SNAPSHOT
  final_snapshot_identifier = var.RDS_FINAL_SNAPSHOT_IDENTIFIER

  db_subnet_group_name = aws_db_subnet_group.rds_db_subgroup.name

  performance_insights_enabled = var.RDS_PERFORMANCE_INSIGHTS_ENABLED
}
