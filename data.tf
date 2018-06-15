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

data "template_file" "appserver_create_custom_users" {
  count = "${length(var.appserver_windows_custom_user_username)}"
  template = "$Password = ConvertTo-SecureString $${custom_password} –AsPlainText –Force; New-LocalUser $${custom_username} -Password $Password -PasswordNeverExpires -AccountNeverExpires -FullName $${custom_username} -Description $${custom_username}; Add-LocalGroupMember -Group Administrators -Member $${custom_username}"

  vars {
    custom_username = "${element(var.appserver_windows_custom_user_username, count.index)}"
    custom_password = "${element(var.appserver_windows_custom_user_password, count.index)}"
  }
}

data "template_file" "blueprism_appserver_setup" {
  count = "${length(var.appserver_private_ip)}"
  template = "${file("${path.module}/templates/appserver_setup.tpl")}"

  vars {
    win_hostname           = "${var.appserver_hostname}-${count.index}"
    dns_suffix_domain_name = "${var.dns_suffix_domain_name}" 

    administrator_password = "${var.appserver_windows_administrator_password}"
    
    create_custom_users = "${ length(var.appserver_windows_custom_user_username) > 0 && length(var.appserver_windows_custom_user_password) > 0 ? join("; ", data.template_file.appserver_create_custom_users.*.rendered) : "" }" 
    
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
data "template_file" "client_create_custom_users" {
  count = "${length(var.client_windows_custom_user_username)}"
  template = "$Password = ConvertTo-SecureString $${custom_password} –AsPlainText –Force; New-LocalUser $${custom_username} -Password $Password -PasswordNeverExpires -AccountNeverExpires -FullName $${custom_username} -Description $${custom_username}; Add-LocalGroupMember -Group Administrators -Member $${custom_username}"

  vars {
    custom_username = "${element(var.client_windows_custom_user_username, count.index)}"
    custom_password = "${element(var.client_windows_custom_user_password, count.index)}"
  }
}

data "template_file" "blueprism_client_setup" {
  count = "${length(var.client_private_ip)}"
  template = "${file("${path.module}/templates/client_setup.tpl")}"

  vars {
    win_hostname           = "${var.client_hostname}-${count.index}"
    dns_suffix_domain_name = "${var.dns_suffix_domain_name}" 

    administrator_password = "${var.client_windows_administrator_password}"
    
    create_custom_users = "${ length(var.client_windows_custom_user_username) > 0 && length(var.client_windows_custom_user_password) > 0 ? join("; ", data.template_file.client_create_custom_users.*.rendered) : "" }" 
    
    blueprism_installer_path = "${var.blueprism_installer_path}"

    appserver_hostname = "${element(var.appserver_private_ip, 0)}"
    appserver_port     = "${var.appserver_port}"

    custom_powershell_commands = "${ length(var.client_custom_powershell_commands) > 0 ? join( "; ", var.client_custom_powershell_commands) : "" }"
  }
}

#-------------------------------------
# AWS EC2 Resource PC for Blue Prism #
#-------------------------------------
data "template_file" "resource_create_custom_users" {
  count = "${length(var.resource_windows_custom_user_username)}"
  template = "$Password = ConvertTo-SecureString $${custom_password} –AsPlainText –Force; New-LocalUser $${custom_username} -Password $Password -PasswordNeverExpires -AccountNeverExpires -FullName $${custom_username} -Description $${custom_username}; Add-LocalGroupMember -Group Administrators -Member $${custom_username}"

  vars {
    custom_username = "${element(var.resource_windows_custom_user_username, count.index)}"
    custom_password = "${element(var.resource_windows_custom_user_password, count.index)}"
  }
}

data "template_file" "blueprism_resource_setup" {
  count = "${length(var.resource_private_ip)}"
  template = "${file("${path.module}/templates/resource_setup.tpl")}"

  vars {
    win_hostname           = "${var.resource_hostname}-${count.index}"
    dns_suffix_domain_name = "${var.dns_suffix_domain_name}" 

    administrator_password = "${var.resource_windows_administrator_password}"

    create_custom_users = "${ length(var.resource_windows_custom_user_username) > 0 && length(var.resource_windows_custom_user_password) > 0 ? join("; ", data.template_file.resource_create_custom_users.*.rendered) : "" }" 
    
    blueprism_installer_path   = "${var.blueprism_installer_path}"
    
    install_login_agent = "${ length(var.login_agent_installer_path) > 0 ? "iwr -Uri ${var.login_agent_installer_path} -OutFile login_agent.msi ; msiexec.exe /i login_agent.msi /qb- ALLUSERS=1 " : "" }"
    
    install_mapi        = "${ length(var.mapi_installer_path) > 0 ? "iwr -Uri ${var.mapi_installer_path} -OutFile mapiex.msi; msiexec.exe /i mapiex.msi /qb- ALLUSERS=1" : "" }"

    appserver_hostname = "${element(var.appserver_private_ip, 0)}"
    appserver_port     = "${var.appserver_port}"

    custom_powershell_commands = "${ length(var.resource_custom_powershell_commands) > 0 ? join( "; ", var.resource_custom_powershell_commands) : "" }"
  }
}
