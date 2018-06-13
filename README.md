# terraform-aws-blueprism

A terraform module to setup Blue Prism Enterprise on AWS.

## Assumptions

- You want to setup Blue Prism Resources such as Appserver, Interactive Client, Resource PC, Database, etc individually in AWS.
- You want these resources to exist within security groups that allow communication and coordination. These can be user provided or created within the module.
- You've created a Virtual Private Cloud (VPC) and subnets with dns hostnames and support enabled where you intend to put the Blue Prism resources.
- You have a private hosted zone (or custom internal DNS servers) configured for this VPC since blueprism communicates using the windows hostname.
- You want to host Blueprism resources in a private subnet within the VPC. AWS Security group policy for now allows incoming communication from all ports and protocols to the appserver, interactive client and resource pcs for the cidr range provided as a variable.
- You want the module to automatically update Blue Prism app/Login agent or license if you update their name or installer path by recreating required resources.

## Usage example

```
module "blueprism" {
  source                = "capsulehealth/terraform-aws-blueprism"
  version               = "1.0.0"
  
  region    = "us-east-2"
  subnet_id = "subnet-2671384a"
  
  blueprism_installer_path = "http://test-bucket.s3.amazonaws.com/BluePrism6.2.1_x64_0.msi"
  blueprism_license_path   = "http://test-bucket.s3.amazonaws.com/BluePrim-prod.lic"
  login_agent_installer_path = "http://test-bucket.s3.amazonaws.com/LoginAgent5.0.23_x64.msi"
  
  dns_suffix_domain_name   = "internal.company.com"

  db_name                      = "company_prod"
  db_master_username           = "dbmaster"
  db_master_password           = "${var.blueprism_db_master_password}"
  db_storage                   = "100"
  db_instance_class            = "db.t2.medium"
  db_subnet_group_name         = "private-vpc-db-subnet"

  # Below passwords can be passed as terraform environment variables
  appserver_windows_administrator_password = "${var.blueprism_appserver_windows_administrator_password}"
  appserver_instance_type                  = "m4.large"
  appserver_private_ip                     = [ "10.0.1.10" ]
  appserver_key_name                       = "blueprism-key"

  appserver_sg_ingress_cidr = [ 
    "10.100.0.0/24",
    "10.0.0.0/16"
  ]

  client_windows_administrator_password  = "${var.blueprism_client_windows_administrator_password}"
  client_windows_custom_user_username    = "eng_team"
  client_windows_custom_user_password    = "${var.blueprism_client_windows_capsule_password}"
  client_private_ip                      = [ "10.0.1.15", "10.0.1.16" ]
  client_key_name                        = "blueprism-key"

  client_sg_ingress_cidr = [ 
    "10.100.0.0/24",
    "10.0.0.0/16"
  ]

  resource_windows_administrator_password  = "${var.blueprism_client_windows_administrator_password}"
  resource_windows_custom_user_username    = "ops_team"
  resource_windows_custom_user_password    = "${var.blueprism_client_windows_capsule_password}"
  resource_instance_type                   = "t2.medium"
  resource_private_ip                      = [ "10.0.1.20", "10.0.1.21", "10.0.1.22" ]
  resource_key_name                        = "blueprism-key"

  resource_sg_ingress_cidr = [ 
    "10.100.0.0/24",
    "10.0.0.0/16"
  ]

  tags {
    Environment = "operations"
  }
}
```

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/CapsuleHealth/terraform-aws-blueprism/issues/new) section.

## Change log

The [changelog](https://github.com/CapsuleHealth/terraform-aws-blueprism/tree/master/CHANGELOG.md) captures all important release notes.

## Authors

Created and maintained by [Capsule Health](https://github.com/CapsuleHealth).
Many thanks to [the contributors listed here](https://github.com/CapsuleHealth/terraform-aws-blueprism/graphs/contributors)!

## License

MIT Licensed. See [LICENSE](https://github.com/CapsuleHealth/terraform-aws-blueprism/tree/master/LICENSE) for full details.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| appserver_disable_api_termination | Boolean flag to disable api termination if set to true for blueprism appserver | string | `false` | no |
| appserver_hostname | Windows hostname that should be assigned to the appserver machine | string | `bp-appserv` | no |
| appserver_instance_type | EC2 instance type for blueprism appserver | string | `t2.small` | no |
| appserver_key_name | Name of the AWS Key Pair that should be used to decrypt the password for appserver | string | `` | no |
| appserver_port | The port on which blueprism appserver should be configured to listen for client/resource pcs | string | `8199` | no |
| appserver_private_ip | List of Private IPs for the blueprism appserver. This module will automatically generate the count value based on the number of elements in the list | list | - | yes |
| appserver_root_volume_size | Root volume size for blueprism appserver in GB | string | `30` | no |
| appserver_sg_ingress_cidr | CIDR IP range from which blueprism appserver can be accessed directly | list | `<list>` | no |
| appserver_windows_administrator_password | Windows password for Administrator user on appserver machine | string | - | yes |
| appserver_windows_custom_user_password | Windows password for Custom user on appserver machine | string | `` | no |
| appserver_windows_custom_user_username | Windows username for Custom user on appserver machine | string | `` | no |
| aws_windows_os | The AWS version of Windows OS that should be installed on all blueprism ec2 resources | string | `Windows_Server-2016-English-Full-Base-*` | no |
| blueprism_installer_path | The complete url to download blueprism installer file from | string | - | yes |
| blueprism_license_path | The complete url to download blueprism license file from | string | - | yes |
| bp_password | Password to login into blueprism application | string | `admin` | no |
| bp_username | Username to login into blueprism application | string | `admin` | no |
| client_disable_api_termination | Boolean flag to disable api termination if set to true for blueprism client | string | `false` | no |
| client_hostname | Windows hostname that should be assigned to the client machine | string | `bp-client` | no |
| client_instance_type | EC2 instance type for blueprism client | string | `t2.small` | no |
| client_key_name | Name of the AWS Key Pair that should be used to decrypt the password for client | string | `` | no |
| client_private_ip | List of Private IPs for the blueprism client. This module will automatically generate the count value based on the number of elements in the list | list | - | yes |
| client_root_volume_size | Root volume size for blueprism client in GB | string | `30` | no |
| client_sg_ingress_cidr | CIDR IP range from which blueprism client can be accessed directly | list | `<list>` | no |
| client_windows_administrator_password | Windows password for Administrator user on client machine | string | - | yes |
| client_windows_custom_user2_password | Windows password for Custom2 user on client machine | string | `` | no |
| client_windows_custom_user2_username | Windows username for Custom2 user on client machine | string | `` | no |
| client_windows_custom_user_password | Windows password for Custom user on client machine | string | `` | no |
| client_windows_custom_user_username | Windows username for Custom user on client machine | string | `` | no |
| create_new_db | Boolean flag to setup new database for blueprism app. It should be set to 'true' for the first time while trying to setup database | string | `false` | no |
| db_backup_retention_period | Database backup retention period for RDS | string | `0` | no |
| db_backup_window | Database backup window for RDS in UTC | string | `04:00-06:00` | no |
| db_changes_apply_immediately | Boolean flag to apply changes to the blueprism database immediately | string | `false` | no |
| db_engine | RDS Database engine for setting up blueprism database | string | `sqlserver-ex` | no |
| db_identifier | The identifier that should be used for the blueprism database | string | `blueprism-db` | no |
| db_instance_class | RDS Database instance class to be used for blueprism database | string | - | yes |
| db_maintenance_window | Database maintenance window for RDS in UTC | string | `Tue:06:30-Tue:07:00` | no |
| db_master_password | Database password in order for appserver to access the database | string | - | yes |
| db_master_username | Database username in order for appserver to access the database | string | - | yes |
| db_name | Name of the database that should be used to connect with blueprism appserver | string | - | yes |
| db_sg_ingress_cidr | CIDR IP range from which blueprism database can be accessed directly | list | `<list>` | no |
| db_sg_policy_name | Database security group policy name for blueprism database | string | `blueprism-db-sg-policy` | no |
| db_snapshot_identifier | Custom snapshot identifier if you want to restore database from that particular snapshot | string | `` | no |
| db_storage | The size of database server that should be allocated in GB | string | - | yes |
| db_storage_type | RDS Database storage type | string | `gp2` | no |
| db_subnet_group_name | Provide a database subnet group name within which blueprism database should be launched | string | - | yes |
| db_timezone | Custom timezone for Microsoft SQL RDS Database | string | `` | no |
| dns_suffix_domain_name | Internal network domain name for your vpc if you have enabled dns_hostnames and dns_support | string | `` | no |
| login_agent_installer_path | The complete url to download blueprism login agent installer file from | string | `` | no |
| region | The aws region in which you wish to create blueprism resources | string | `us-east-1` | no |
| resource_disable_api_termination | Boolean flag to disable api termination if set to true for blueprism resource | string | `false` | no |
| resource_hostname | Windows hostname that should be assigned to the resource pc | string | `bp-resource` | no |
| resource_instance_type | EC2 instance type for blueprism resource | string | `t2.small` | no |
| resource_key_name | Name of the AWS Key Pair that should be used to decrypt the password for resource | string | `` | no |
| resource_private_ip | List of Private IPs for the blueprism resource. This module will automatically generate the count value based on the number of elements in the list | list | - | yes |
| resource_root_volume_size | Root volume size for blueprism resource in GB | string | `30` | no |
| resource_sg_ingress_cidr | CIDR IP range from which blueprism resource can be accessed directly | list | `<list>` | no |
| resource_windows_administrator_password | Windows password for Administrator user on resource pc | string | - | yes |
| resource_windows_custom_user2_password | Windows password for Custom2 user on resource pc | string | `` | no |
| resource_windows_custom_user2_username | Windows username for Custom2 user on resource pc | string | `` | no |
| resource_windows_custom_user_password | Windows password for Custom user on resource pc | string | `` | no |
| resource_windows_custom_user_username | Windows username for Custom user on resource pc | string | `` | no |
| subnet_id | The aws subnet id of the subnet in which you want to create all blueprism ec2 resources | string | - | yes |
| tags | A map of tags to add to all blueprism resources | string | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| appserver_count | Count of total number of blueprism appservers created |
| appserver_hostname | Windows hostname for blueprism appserver machines. There will be a hyphen number suffixed to it to identify the individual machine |
| appserver_instance_id | The list of instance ids for all blueprism appservers created |
| appserver_private_ip | The list of private ips for all blueprism appservers created |
| client_count | Count of total number of blueprism clients created |
| client_hostname | Windows hostname for blueprism client machines. There will be a hyphen number suffixed to it to identify the individual machine |
| client_instance_id | The list of instance ids for all blueprism clients created |
| client_private_ip | The list of private ips for all blueprism clients created |
| db_address | The address for blueprism database in RDS |
| db_endpoint | The endpoint for blueprism database in RDS |
| db_identifier | The identifier for blueprism database in RDS |
| resource_count | Count of total number of blueprism resource pcs created |
| resource_hostname | Windows hostname for blueprism resource pcs. There will be a hyphen number suffixed to it to identify the individual machine |
| resource_instance_id | The list of instance ids for all blueprism resource pcs created |
| resource_private_ip | The list of private ips for all blueprism resource pcs created |
