#-----------------------------------
# AWS EC2 AppServer for Blue Prism #
#-----------------------------------
data "aws_ami" "windows" {
    most_recent = true
    owners      = ["amazon"]

    filter {
      name   = "name"
      values = [ "${var.aws_windows_os}" ]
    }
}

data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

data "template_file" "blueprism_appserver_setup" {
  count = "${length(var.appserver_private_ip)}"
  template = "${file("${path.module}/templates/appserver_setup.tpl")}"

  vars {
    win_hostname           = "${var.appserver_hostname}-${count.index}"
    dns_suffix_domain_name = "${var.dns_suffix_domain_name}" 

    administrator_password = "${var.appserver_windows_administrator_password}"
    custom_user_username   = "${var.appserver_windows_custom_user_username}"
    custom_user_password   = "${var.appserver_windows_custom_user_password}"
    
    blueprism_installer_path = "${var.blueprism_installer_path}"
    blueprism_license_path   = "${var.blueprism_license_path}"

    db_name     = "${var.db_name}"
    db_username = "${var.db_master_username}"
    db_password = "${var.db_master_password}"
    db_hostname = "${aws_db_instance.blueprism_db.address}"
    bp_username = "${var.bp_username}"
    bp_password = "${var.bp_password}"

    create_new_db_for_first_use = "${var.create_new_db ? "AutomateC.exe /createdb ${var.db_master_password}" : "" }"

    appserver_port     = "${var.appserver_port}"

    custom_powershell_commands = "${ length(var.appserver_custom_powershell_commands) > 0 ? join( "; ", var.appserver_custom_powershell_commands) : "" }"
  }
}

#--------------------------------------------
# AWS EC2 Interactive Client for Blue Prism #
#--------------------------------------------
data "template_file" "blueprism_client_setup" {
  count = "${length(var.client_private_ip)}"
  template = "${file("${path.module}/templates/client_setup.tpl")}"

  vars {
    win_hostname           = "${var.client_hostname}-${count.index}"
    dns_suffix_domain_name = "${var.dns_suffix_domain_name}" 

    administrator_password = "${var.client_windows_administrator_password}"
    custom_user_username   = "${var.client_windows_custom_user_username}"
    custom_user_password   = "${var.client_windows_custom_user_password}"
    custom_user2_username  = "${var.client_windows_custom_user2_username}"
    custom_user2_password  = "${var.client_windows_custom_user2_password}"
    
    blueprism_installer_path = "${var.blueprism_installer_path}"

    appserver_hostname = "${element(var.appserver_private_ip, 0)}"
    appserver_port     = "${var.appserver_port}"

    custom_powershell_commands = "${ length(var.client_custom_powershell_commands) > 0 ? join( "; ", var.client_custom_powershell_commands) : "" }"
  }
}

#-------------------------------------
# AWS EC2 Resource PC for Blue Prism #
#-------------------------------------
data "template_file" "blueprism_resource_setup" {
  count = "${length(var.resource_private_ip)}"
  template = "${file("${path.module}/templates/resource_setup.tpl")}"

  vars {
    win_hostname           = "${var.resource_hostname}-${count.index}"
    dns_suffix_domain_name = "${var.dns_suffix_domain_name}" 

    administrator_password = "${var.resource_windows_administrator_password}"
    custom_user_username   = "${var.resource_windows_custom_user_username}"
    custom_user_password   = "${var.resource_windows_custom_user_password}"
    
    blueprism_installer_path   = "${var.blueprism_installer_path}"
    
    install_login_agent = "${var.login_agent_installer_path ? "iwr -Uri "${var.login_agent_installer_path}" -OutFile login_agent.msi ; msiexec.exe /i login_agent.msi /qb- ALLUSERS=1 " : "" }"
    
    install_mapi        = "${var.mapi_installer_path ? "iwr -Uri "${var.mapi_installer_path}" -OutFile mapiex.msi; msiexec.exe /i mapiex.msi /qb- ALLUSERS=1" : "" }"

    appserver_hostname = "${element(var.appserver_private_ip, 0)}"
    appserver_port     = "${var.appserver_port}"

    custom_powershell_commands = "${ length(var.resource_custom_powershell_commands) > 0 ? join( "; ", var.resource_custom_powershell_commands) : "" }"
  }
}
