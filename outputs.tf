output "db_identifier" {
  description = "The identifier for Blue Prism database in RDS"
  value       = "${aws_db_instance.blueprism_db.identifier}"
}

output "db_endpoint" {
  description = "The endpoint for Blue Prism database in RDS"
  value       = "${aws_db_instance.blueprism_db.endpoint}"
}

output "db_address" {
  description = "The address for Blue Prism database in RDS"
  value       = "${aws_db_instance.blueprism_db.address}"
}

output "appserver_private_ip" {
  description = "The list of private ips for all Blue Prism appservers created"
  value       = "${aws_instance.blueprism_appserver.*.private_ip}"
}

output "appserver_instance_id" {
  description = "The list of instance ids for all Blue Prism appservers created"
  value       = "${aws_instance.blueprism_appserver.*.id}"
}

output "appserver_count" {
  description = "Count of total number of Blue Prism appservers created"
  value       = "${length(aws_instance.blueprism_appserver.*.id)}"
}

output "appserver_hostname" {
  description = "Windows hostname for Blue Prism appserver machines. There will be a hyphen number suffixed to it to identify the individual machine"
  value       = "${var.appserver_hostname}"
}

output "client_private_ip" {
  description = "The list of private ips for all Blue Prism clients created"
  value       = "${aws_instance.blueprism_client.*.private_ip}"
}

output "client_instance_id" {
  description = "The list of instance ids for all Blue Prism clients created"
  value       = "${aws_instance.blueprism_client.*.id}"
}

output "client_count" {
  description = "Count of total number of Blue Prism clients created"
  value       = "${length(aws_instance.blueprism_client.*.id)}"
}

output "client_hostname" {
  description = "Windows hostname for Blue Prism client machines. There will be a hyphen number suffixed to it to identify the individual machine"
  value       = "${var.client_hostname}"
}

output "resource_private_ip" {
  description = "The list of private ips for all Blue Prism resource pcs created"
  value       = "${aws_instance.blueprism_resource.*.private_ip}"
}

output "resource_instance_id" {
  description = "The list of instance ids for all Blue Prism resource pcs created"
  value       = "${aws_instance.blueprism_resource.*.id}"
}

output "resource_count" {
  description = "Count of total number of Blue Prism resource pcs created"
  value       = "${length(aws_instance.blueprism_resource.*.id)}"
}

output "resource_hostname" {
  description = "Windows hostname for Blue Prism resource pcs. There will be a hyphen number suffixed to it to identify the individual machine"
  value       = "${var.resource_hostname}"
}
