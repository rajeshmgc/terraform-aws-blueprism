variable "region" {
  description = "The aws region in which you wish to create blueprism resources"
  default     = "us-east-2"
}

variable "subnet_id" {
  description = "The aws subnet id of the subnet in which you want to create all blueprism resources"
}

variable "tags" {
  description = "A map of tags to add to all blueprism resources"
  default     = {}
}

variable "blueprism_installer_path" { 
  description = "The complete url to download blueprism installer file from"
}

variable "blueprism_license_path" {
  description = "The complete url to download blueprism license file from"
}

variable "login_agent_installer_path" { 
  description = "The complete url to download blueprism login agent installer file from" 
  default     = "" 
}

variable "dns_suffix_domain_name" {
  description = "Internal network domain name for your vpc if you have enabled dns_hostnames and dns_support"
  default     = ""
}

variable "bp_username" {
  description = "Username to login into blueprism application"
  default     = "admin"
}

variable "bp_password" {
  description = "Password to login into blueprism application"
  default     = "admin"
}

variable "create_new_db" {
  description = "Boolean flag to setup new database for blueprism app. It should be set to 'true' for the first time while trying to setup database"
  default     = false }

variable "db_name" {
  description = "Name of the database that should be used to connect with blueprism appserver"
}

variable "db_master_username" {
  description = "Database username in order for appserver to access the database"
}

variable "db_master_password" {
  description = "Database password in order for appserver to access the database"
}

variable "db_storage" {
  description = "The size of database server that should be allocated in GB"
}

variable "db_storage_type" {
  description = "RDS Database storage type"
  default     = "gp2"
}

variable "db_engine" {
  description = "RDS Database engine for setting up blueprism database"
  default     = "sqlserver-ex"
}

variable "db_identifier" {
  description = "The identifier that should be used for the blueprism database"
  default     = "blueprism-db"
}

variable "db_changes_apply_immediately" {
  description = "Boolean flag to apply changes to the blueprism database immediately"
  default     = false
}

variable "db_instance_class" {
  description = "RDS Database instance class to be used for blueprism database"
}

variable "db_subnet_group_name" {
  description = "Provide a database subnet group name within which blueprism database should be launched"
}

variable "db_timezone" {
  description = "Custom timezone for Microsoft SQL RDS Database"
  default     = ""
}

variable "db_snapshot_identifier" {
  # Please pass the snapshot id value to default when creating a new db instance from a backup
  description = "Custom snapshot identifier if you want to restore database from that particular snapshot"
  default     = ""
}
variable "db_backup_retention_period" {
  description = "Database backup retention period for RDS"
  default     = 0 }

variable "db_backup_window" {
  description = "Database backup window for RDS"
}

variable "db_maintenance_window" {
  description = "Database maintenance window for RDS"
}

variable "db_sg_policy_name" {
  description = "Database security group policy name for blueprism database"
  default     = "blueprism-db-sg-policy"
}

variable "db_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which blueprism database can be accessed directly"
}

variable "appserver_hostname" {
  description = "Windows hostname that should be assigned to the appserver machine"
  default     = "bp-appserv"
}

variable "appserver_windows_administrator_password" {
  description = "Windows password for Administrator user on appserver machine"
}

variable "appserver_windows_custom_user_username" {
  description = "Windows username for Custom user on appserver machine"
}

variable "appserver_windows_custom_user_password" {
  description = "Windows password for Custom user on appserver machine"
}

variable "appserver_instance_type" {
  description = "EC2 instance type for blueprism appserver"
}

variable "appserver_disable_api_termination" {
  description = "Boolean flag to disable api termination if set to true for blueprism appserver"
  default     = false 
}

variable "appserver_root_volume_size" {
  description = "Root volume size for blueprism appserver in GB"
  default     = 30 
}

variable "appserver_private_ip" { 
  type        = "list"
  description = "List of Private IPs for the blueprism appserver. This module will automatically generate the count value based on the number of elements in the list"
  default     = [ "" ]
}
variable "appserver_key_name" {
  description = "Name of the AWS Key Pair that should be used to decrypt the password for appserver"
  default     = ""
}

variable "appserver_port" {
  description = "The port on which blueprism appserver should be configured to listen for client/resource pcs"
  default     = "8199"
}

variable "appserver_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which blueprism appserver can be accessed directly"
}

variable "client_hostname" {
  description = "Windows hostname that should be assigned to the client machine"
  default     = "bp-client"
}

variable "client_windows_administrator_password" {
  description = "Windows password for Administrator user on client machine"
}

variable "client_windows_custom_user_username" {
  description = "Windows username for Custom user on client machine"
}

variable "client_windows_custom_user_password" {
  description = "Windows password for Custom user on client machine"
}

variable "client_windows_custom_user2_username" {
  description = "Windows username for Custom2 user on client machine"
}

variable "client_windows_custom_user2_password" {
  description = "Windows password for Custom2 user on client machine"
}

variable "client_instance_type" {
  description = "EC2 instance type for blueprism client"
}

variable "client_disable_api_termination" {
  description = "Boolean flag to disable api termination if set to true for blueprism client"
  default     = false
}

variable "client_root_volume_size" {
  description = "Root volume size for blueprism client in GB"
  default     = 30 
}

variable "client_private_ip" { 
  type        = "list"
  description = "List of Private IPs for the blueprism client. This module will automatically generate the count value based on the number of elements in the list"
  default     = [ "" ]
}

variable "client_key_name" {
  description = "Name of the AWS Key Pair that should be used to decrypt the password for client"
  default     = ""
}

variable "client_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which blueprism client can be accessed directly"
  default     = [ "0.0.0.0/0" ]
}

variable "resource_hostname" {
  description = "Windows hostname that should be assigned to the resource pc"
  default     = "bp-resource"
}

variable "resource_windows_administrator_password" {
  description = "Windows password for Administrator user on resource pc"
}

variable "resource_windows_custom_user_username" {
  description = "Windows username for Custom user on resource pc"
}

variable "resource_windows_custom_user_password" {
  description = "Windows password for Custom user on resource pc"
}

variable "resource_windows_custom_user2_username" {
  description = "Windows username for Custom2 user on resource pc"
}

variable "resource_windows_custom_user2_password" {
  description = "Windows password for Custom2 user on resource pc"
}

variable "resource_instance_type" {
  description = "EC2 instance type for blueprism resource"
}

variable "resource_disable_api_termination" {
  description = "Boolean flag to disable api termination if set to true for blueprism resource"
  default     = false
}

variable "resource_root_volume_size" {
  description = "Root volume size for blueprism resource in GB"
  default     = 30 
}

variable "resource_private_ip" { 
  type        = "list" 
  description = "List of Private IPs for the blueprism resource. This module will automatically generate the count value based on the number of elements in the list"
  default     = [ "" ]
}

variable "resource_key_name" {
  description = "Name of the AWS Key Pair that should be used to decrypt the password for resource"
  default     = ""
}

variable "resource_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which blueprism resource can be accessed directly"
  default     = [ "0.0.0.0/0" ]
}
