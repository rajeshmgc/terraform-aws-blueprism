output "db_identifier" {
  description = "The identifier for blueprism database in RDS"
  value       = "${aws_db_instance.blueprism_db.identifier}"
}

output "db_endpoint" {
  description = "The endpoint for blueprism database in RDS"
  value       = "${aws_db_instance.blueprism_db.endpoint}"
}

output "db_address" {
  description = "The address for blueprism database in RDS"
  value       = "${aws_db_instance.blueprism_db.address}"
}

output "appserver_private_ip" {
  description = "The list of private ips for all blueprism appservers created"
  value       = "${aws_instance.blueprism_appserver.*.private_ip}"
}

output "appserver_instance_id" {
  description = "The list of instance ids for all blueprism appservers created"
  value       = "${aws_instance.blueprism_appserver.*.id}"
}

output "appserver_count" {
  description = "Count of total number of blueprism appservers created"
  value       = "${length(aws_instance.blueprism_appserver.*.id)}"
}

output "appserver_hostname" {
  description = "Windows hostname for blueprism appserver machines. There will be a hyphen number suffixed to it to identify the individual machine"
  value       = "${var.appserver_hostname}"
}

output "client_private_ip" {
  description = "The list of private ips for all blueprism clients created"
  value       = "${aws_instance.blueprism_client.*.private_ip}"
}

output "client_instance_id" {
  description = "The list of instance ids for all blueprism clients created"
  value       = "${aws_instance.blueprism_client.*.id}"
}

output "client_count" {
  description = "Count of total number of blueprism clients created"
  value       = "${length(aws_instance.blueprism_client.*.id)}"
}

output "client_hostname" {
  description = "Windows hostname for blueprism client machines. There will be a hyphen number suffixed to it to identify the individual machine"
  value       = "${var.client_hostname}"
}

output "resource_private_ip" {
  description = "The list of private ips for all blueprism resource pcs created"
  value       = "${aws_instance.blueprism_resource.*.private_ip}"
}

output "resource_instance_id" {
  description = "The list of instance ids for all blueprism resource pcs created"
  value       = "${aws_instance.blueprism_resource.*.id}"
}

output "resource_count" {
  description = "Count of total number of blueprism resource pcs created"
  value       = "${length(aws_instance.blueprism_resource.*.id)}"
}

output "resource_hostname" {
  description = "Windows hostname for blueprism resource pcs. There will be a hyphen number suffixed to it to identify the individual machine"
  value       = "${var.resource_hostname}"
}
