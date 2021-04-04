resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = format("%.20s", "redis-${var.EKS_PROJECT_TAG}")
  replication_group_description = "ElastiCache replication group for redis-${var.EKS_PROJECT_TAG}"
  number_cache_clusters         = var.REDIS_CLUSTERS
  availability_zones            = var.AVAILABILITY_ZONES
  engine                        = var.ENGINE
  node_type                     = var.REDIS_NODE_TYPE
  automatic_failover_enabled    = var.REDIS_AUTOMATIC_FAILOVER_ENABLED
  engine_version                = var.REDIS_ENGINE_VERSION
  port                          = var.REDIS_PORT
  snapshot_window               = var.REDIS_SNAPSHOT_WINDOW
  snapshot_retention_limit      = var.REDIS_SNAPSHOT_RETENTION_LIMIT
  auto_minor_version_upgrade    = var.AUTO_MINOR_VERSION_UPGRADE
  at_rest_encryption_enabled    = var.AT_REST_ENCRYPTION_ENABLED
  parameter_group_name          = aws_elasticache_parameter_group.redis_parameter_group.id
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.id
  security_group_ids            = [aws_security_group.redis_security_group.id]
  apply_immediately             = var.APPLY_IMMEDIATELY
  maintenance_window            = var.REDIS_MAINTENANCE_WINDOW
  tags = {
    Owner = var.EKS_PROJECT_TAG
    Project = var.EKS_PROJECT_TAG
  }
}

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name = "redis-${var.EKS_PROJECT_TAG}-pg"

  description = "ElastiCache redis parameter group for ${var.EKS_PROJECT_TAG}"

  # Strip the patch version from redis_version var
  family = "redis${replace(var.REDIS_ENGINE_VERSION, "/\\.[\\d]+$/", "")}"
  dynamic "parameter" {
    for_each = var.REDIS_PARAMETERS
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name = "redis-${var.EKS_PROJECT_TAG}-subnet"
  subnet_ids = module.cluster.private_subnet_ids
}


resource "aws_security_group" "redis_security_group" {
  name        = format("%.255s", "tf-sg-ec-${var.EKS_PROJECT_TAG}")
  description = "ElastiCache security group for ${var.EKS_PROJECT_TAG}}"
  vpc_id      = module.cluster.vpc_id

  tags = {
    Name = "tf-sg-ec-${var.EKS_PROJECT_TAG}"
  }
}

resource "aws_security_group_rule" "redis_ingress" {
  count                    = length(var.ALLOWED_SECURITY_GROUPS)
  type                     = "ingress"
  from_port                = var.REDIS_PORT
  to_port                  = var.REDIS_PORT
  protocol                 = "tcp"
  source_security_group_id = element(var.ALLOWED_SECURITY_GROUPS, count.index)
  security_group_id        = aws_security_group.redis_security_group.id
}

resource "aws_security_group_rule" "redis_networks_ingress" {
  type              = "ingress"
  from_port         = var.REDIS_PORT
  to_port           = var.REDIS_PORT
  protocol          = "tcp"
  cidr_blocks       = var.ALLOWED_CIDR
  security_group_id = aws_security_group.redis_security_group.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redis_security_group.id
}