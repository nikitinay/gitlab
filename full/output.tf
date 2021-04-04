
output "VPC_ID" {
    value = module.cluster.vpc_id
}

output "DB-ADDRESS" {
    value = aws_db_instance.rds_db.address
}

output "DB-NAME" {
    value = aws_db_instance.rds_db.name
}

output "DB-ARN" {
    value = aws_db_instance.rds_db.arn
}

output "DB-DOMAIN" {
    value = aws_db_instance.rds_db.domain
}

output "DB-ID" {
    value = aws_db_instance.rds_db.id
}

output "DB-PORT" {
    value = aws_db_instance.rds_db.port
}

output "DELETE_PROTECTION" {
    value = aws_db_instance.rds_db.deletion_protection
}


output "REDIS_SECURITY_GROUP_ID" {
  value = aws_security_group.redis_security_group.id
}

output "PARAMETER_GROUP" {
  value = aws_elasticache_parameter_group.redis_parameter_group.id
}

output "SUBNET_GROUP_NAME" {
  value = aws_elasticache_subnet_group.redis_subnet_group.name
}

output "ID" {
  value = aws_elasticache_replication_group.redis.id
}

output "PORT" {
  value = var.REDIS_PORT
}

output "ENDPOINT" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}
