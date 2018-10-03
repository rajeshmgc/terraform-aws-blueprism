variable "subnet_id" {
  description = "The aws subnet id of the subnet in which you want to create all Blue Prism ec2 resources"
}

variable "tags" {
  description = "A map of tags to add to all Blue Prism resources"
  default     = {}
}

variable "blueprism_installer_path" { 
  description = "The complete url to download Blue Prism installer file from"
}

variable "blueprism_license_path" {
  description = "The complete url to download Blue Prism license file from"
}

variable "login_agent_installer_path" { 
  description = "The complete url to download Blue Prism login agent installer file from and install on Resource PC" 
  default     = ""
}

variable "mapi_installer_path" { 
  description = "The complete url to download Blue Prism MAPI Ex installer file from and install on Resource PC" 
  default     = ""
}

variable "dns_suffix_domain_name" {
  description = "Internal network domain name for your vpc if you have enabled dns_hostnames and dns_support"
  default     = ""
}

variable "aws_windows_ami" {
  description = "The AWS version of Windows OS that should be installed on all Blue Prism ec2 resources"
  default     = "Windows_Server-2016-English-Full-Base-*"
}

variable "bp_username" {
  description = "Username to login into Blue Prism application"
  default     = "admin"
}

variable "bp_password" {
  description = "Password to login into Blue Prism application"
  default     = "admin"
}

variable "create_new_db" {
  description = "Boolean flag to setup new database for Blue Prism app. It should be set to 'true' for the first time while trying to setup database"
  default     = false }

variable "db_name" {
  description = "Name of the database that should be used to connect with Blue Prism appserver"
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
  description = "RDS Database engine for setting up Blue Prism database"
  default     = "sqlserver-ex"
}

variable "db_identifier" {
  description = "The identifier that should be used for the Blue Prism database"
  default     = "blueprism-db"
}

variable "db_changes_apply_immediately" {
  description = "Boolean flag to apply changes to the Blue Prism database immediately"
  default     = false
}

variable "db_instance_class" {
  description = "RDS Database instance class to be used for Blue Prism database"

}

variable "db_subnet_group_name" {
  description = "Provide a database subnet group name within which Blue Prism database should be launched"
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

variable "db_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = "false"
}

variable "db_kms_key_id" {
  description = "If db_storage_encrypted is true, the KMS key identifier for the encrypted DB instance"
  default     = ""
}

variable "db_backup_retention_period" {
  description = "Database backup retention period for RDS"
  default     = 0 }

variable "db_backup_window" {
  description = "Database backup window for RDS in UTC"
  default     = "04:00-06:00"
}

variable "db_maintenance_window" {
  description = "Database maintenance window for RDS in UTC"
  default     = "Tue:06:30-Tue:07:00"
}

variable "db_sg_policy_name" {
  description = "Database security group policy name for Blue Prism database"
  default     = "blueprism-db-sg-policy"
}

variable "db_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which Blue Prism database can be accessed directly"
  default     = []
}

variable "appserver_ami" {
  description = "The AWS AMI name that should be used to setup Blue Prism Appserver on"
  default     = ""
}

variable "appserver_hostname" {
  description = "Windows hostname that should be assigned to the appserver machine"
  default     = "bp-appserv"
}

variable "appserver_windows_administrator_password" {
  description = "Windows password for Administrator user on appserver machine"
}

variable "appserver_windows_custom_user_username" {
  type        = "list"
  description = "List of custom usernames for Windows login that needs to be created on appserver"
  default     = []
}

variable "appserver_windows_custom_user_password" {
  type        = "list"
  description = "List of passwords for Windows login mapped to custom usernames for appserver"
  default     = []
}

variable "appserver_instance_type" {
  description = "EC2 instance type for Blue Prism appserver"
  default     = "t2.small"
}

variable "appserver_disable_api_termination" {
  description = "Boolean flag to disable api termination if set to true for Blue Prism appserver"
  default     = false
}

variable "appserver_root_volume_size" {
  description = "Root volume size for Blue Prism appserver in GB"
  default     = 30 
}

variable "appserver_private_ip" { 
  type        = "list"
  description = "List of Private IPs for the Blue Prism appserver. This module will automatically generate the count value based on the number of elements in the list"
}

variable "appserver_key_name" {
  description = "Name of the AWS Key Pair that should be used to decrypt the password for appserver"
  default     = ""
}

variable "appserver_port" {
  description = "The port on which Blue Prism appserver should be configured to listen for client/resource pcs"
  default     = "8199"
}

variable "appserver_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which Blue Prism appserver can be accessed directly"
  default     = [ "0.0.0.0/0" ]
}

variable "appserver_custom_powershell_commands" {
  type        = "list"
  description = "List of custom powershell commands you would like to run while creating a Blue Prism Appserver machine. These will only be executed once when a new instance is created"
  default     = []
}

variable "client_ami" {
  description = "The AWS AMI name that should be used to setup Blue Prism Interactive Client on"
  default     = ""
}

variable "client_hostname" {
  description = "Windows hostname that should be assigned to the client machine"
  default     = "bp-client"
}

variable "client_windows_administrator_password" {
  description = "Windows password for Administrator user on client machine"
}

variable "client_windows_custom_user_username" {
  type        = "list"
  description = "List of custom usernames for Windows login that needs to be created on client"
  default     = []
}

variable "client_windows_custom_user_password" {
  type        = "list"
  description = "List of passwords for Windows login mapped to custom usernames for client"
  default     = []
}

variable "client_instance_type" {
  description = "EC2 instance type for Blue Prism client"
  default     = "t2.small"
}

variable "client_disable_api_termination" {
  description = "Boolean flag to disable api termination if set to true for Blue Prism client"
  default     = false
}

variable "client_root_volume_size" {
  description = "Root volume size for Blue Prism client in GB"
  default     = 30 
}

variable "client_private_ip" { 
  type        = "list"
  description = "List of Private IPs for the Blue Prism client. This module will automatically generate the count value based on the number of elements in the list"
}

variable "client_key_name" {
  description = "Name of the AWS Key Pair that should be used to decrypt the password for client"
  default     = ""
}

variable "client_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which Blue Prism client can be accessed directly"
  default     = [ "0.0.0.0/0" ]
}

variable "client_custom_powershell_commands" {
  type        = "list"
  description = "List of custom powershell commands you would like to run while creating a Blue Prism Interative Client machine. These will only be executed once when a new instance is created"
  default     = []
}

variable "resource_ami" {
  description = "The AWS AMI name that should be used to setup Blue Prism Resource pc on"
  default     = ""
}

variable "resource_hostname" {
  description = "Windows hostname that should be assigned to the resource pc"
  default     = "bp-resource"
}

variable "resource_windows_administrator_password" {
  description = "Windows password for Administrator user on resource pc"
}

variable "resource_windows_custom_user_username" {
  type        = "list"
  description = "List of custom usernames for Windows login that needs to be created on resource pc"
  default     = []
}

variable "resource_windows_custom_user_password" {
  type        = "list"
  description = "List of passwords for Windows login mapped to custom usernames for resource pc"
  default     = []
}

variable "resource_instance_type" {
  description = "EC2 instance type for Blue Prism resource"
  default     = "t2.small"
}

variable "resource_disable_api_termination" {
  description = "Boolean flag to disable api termination if set to true for Blue Prism resource"
  default     = false
}

variable "resource_root_volume_size" {
  description = "Root volume size for Blue Prism resource in GB"
  default     = 30 
}

variable "resource_private_ip" { 
  type        = "list" 
  description = "List of Private IPs for the Blue Prism resource. This module will automatically generate the count value based on the number of elements in the list"
}

variable "resource_key_name" {
  description = "Name of the AWS Key Pair that should be used to decrypt the password for resource"
  default     = ""
}

variable "resource_sg_ingress_cidr" { 
  type        = "list"
  description = "CIDR IP range from which Blue Prism resource can be accessed directly"
  default     = [ "0.0.0.0/0" ]
}

variable "resource_custom_powershell_commands" {
  type        = "list"
  description = "List of custom powershell commands you would like to run while creating a Blue Prism Resource pc. These will only be executed once when a new instance is created"
  default     = []
}
