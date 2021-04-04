variable REGION {
  default = "eu-west-2"
}

variable NAME {
  default = "gitlab-k8s"
}

variable USERNAME {
  default = "aws"
}

variable VPC_CIDR {
  default = "10.0.0.0/22"
}

variable PUBLIC_SUBNET_CIDRS {
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable PRIVATE_SUBNET_CIDRS {
  default = ["10.0.2.0/24", "10.0.3.0/24"] 
}

variable STATE_DIR {
  default = "."
}

variable EKS_OWNER_TAG {
  default = "gitlab"
}

variable EKS_PROJECT_TAG {
  default = "gitlab"
}

variable REGISTRY_ROOT_CA {
  default =""
}

variable K8S_EKS_VERSION {
  default = "1.19"
}


# RDS
variable RDS_IDENTIFIER {
  default = "rdsgitlab"
}

variable RDS_SUBNET_GROUP_NAME {
  default = "rds_subnet_group"
}

variable RDS_ENGINE {
  default = "postgres"
}

variable RDS_ENGINE_VERSION {
  default = "11.7"
}

variable RDS_INSTANCE_CLASS {
  default = "db.t2.small"
}
  
variable RDS_ALLOCATED_STORAGE {
  default = 20
} # 20 GB

variable RDS_STORAGE_TYPE {
  default = "gp2"
}   # General purpose ssd

variable RDS_STORAGE_ENCRYPTED {
  default = false
}  # not supported for db.t2.micro instane

variable RDS_DB_NAME  {
  default = "gitlabhq_production"
}  # use empty string to start without a database created

variable RDS_USERNAME  {
  default = "gitlab" # provide via env vars
} 
 
 variable RDS_PASSWORD  {
  default = "db_pass1" # provided via env vars
}

variable RDS_PORT  {
  default = 5432
}

variable RDS_MULTI_AZ  {
  default = false
}
variable RDS_ALLOW_MAJOR_VERSION_UPGRADE {
  default = false
}

variable RDS_AUTO_MINOR_VERSION_UPGRADE {
  default = true
}
variable RDS_PERFORMANCE_INSIGHTS_ENABLED {
  default = false
}

variable RDS_BACKUP_WINDOW {
  default = "00:00-03:00"
}

variable RDS_BACKUP_RETENTION_PERIOD {
  default = 7
}

variable RDS_PUBLICLY_ACCESSIBLE  {
  default = false
}

variable RDS_FINAL_SNAPSHOT_IDENTIFIER {
  default = "rdssnapshot"
} # name of the final snapshot after deletion # only available if RDS_SKIP_FINAL_SNAPSHOT = false

variable RDS_SNAPSHOT_IDENTIFIER  {
  default = "rdsnapshot"
} # only used if launching rds from a snapshot


variable RDS_DELETION_PROTECTION {
  default = false
}

variable RDS_SKIP_FINAL_SNAPSHOT {
  default = true
}


#REDIS

variable "APPLY_IMMEDIATELY" {
  type        = bool
  default     = true
}

variable "ALLOWED_CIDR" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ALLOWED_SECURITY_GROUPS" {
  type        = list(string)
  default     = []
}

variable "REDIS_CLUSTERS" {
  description = "Number of Redis cache clusters (nodes) to create"
  type        = string
  default = 2
}

variable "AT_REST_ENCRYPTION_ENABLED" {
  type    = bool
  default = true
}

variable "REDIS_AUTOMATIC_FAILOVER_ENABLED" {
  type    = bool
  default = true
}

variable "AUTO_MINOR_VERSION_UPGRADE" {
  type    = bool
  default = true
}

variable "REDIS_NODE_TYPE" {
  type        = string
  default     = "cache.t2.small"
}

variable "REDIS_PORT" {
  type    = number
  default = 6379
}

variable "REDIS_ENGINE_VERSION" {
  type        = string
  default     = "6.x"
}

variable "ENGINE" {
  default     = "redis"
}

variable "REDIS_PARAMETERS" {
  type        = list(map(any))
  default     = []
}

variable "REDIS_MAINTENANCE_WINDOW" {
  type        = string
  default     = "sat:00:00-sat:02:00"
}

variable "REDIS_SNAPSHOT_WINDOW" {
  type        = string
  default     = "03:00-04:00"
}

variable "REDIS_SNAPSHOT_RETENTION_LIMIT" {
  type        = number
  default     = 14
}

variable "AVAILABILITY_ZONES" {
  type        = list(string)
  default = ["eu-west-2a","eu-west-2b"]
}

