<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
</script>
<powershell>
  # Allow incoming ping request from internal network
  Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In;Enable-NetFirewallRule -Name FPS-ICMP6-ERQ-In

  # Allow incoming remote connection using WinRM
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow

  # Allow incoming connection to port 8199
  netsh advfirewall firewall add rule name="Open Port 8199" dir=in action=allow protocol=TCP localport=8199

  # Allow incoming connection for below url for Blueprism appserver
  netsh http add urlacl url=http://+:8199/bpserver user=administrator

  # Set Administrator password
  $Admin = [adsi]("WinNT://./administrator, user")
  $Admin.psbase.invoke("SetPassword", "${administrator_password}")

  # Create new custom user
  $Password = ConvertTo-SecureString "${custom_user_password}" –AsPlainText –Force
  New-LocalUser "${custom_user_username}" -Password $Password -PasswordNeverExpires -AccountNeverExpires -FullName "${custom_user_username}" -Description "${custom_user_username}"

  # Give Administrator rights to new custom user
  Add-LocalGroupMember -Group "Administrators" -Member "${custom_user_username}"

  # Add Blue Prism dir to the path variable permanently 
  #---------------------------------------------------- 
  $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path 
  $newpath = "$oldpath;C:\Program Files\Blue Prism Limited\Blue Prism Automate" 
  Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath 
  $env:Path += ";C:\Program Files\Blue Prism Limited\Blue Prism Automate" 

  # Download Blue Prism Production License Key 
  #------------------------------------------- 
  iwr -Uri "${blueprism_license_path}" -OutFile blueprism.lic 

  # Download Blue Prism installer file 
  #----------------------------------- 
  iwr -Uri "${blueprism_installer_path}" -OutFile blueprism.msi 

  # Install Blue Prism Executable 
  #------------------------------ 
  msiexec.exe /i blueprism.msi /qb- ALLUSERS=1 

  sleep 10

  # Configure Database Connection with Blue Prism 
  #---------------------------------------------- 
  Automate.exe /dbconname "default" /setdbname "${db_name}" /setdbserver "${db_hostname}" /setdbusername "${db_username}" /setdbpassword "${db_password}" 

  sleep 10

  # Below command should only be used first time 
  # to create a new db for Blueprism
  #---------------------------------------------
  ${create_new_db_for_first_use}

  AutomateC.exe /license "blueprism.lic" /user "${bp_username}" "${bp_password}"   

  AutomateC.exe /serverconfig "default" "default" "${appserver_port}" /encryptionscheme "Default Encryption Scheme" 3 /dbconname default /connectionmode 5 
  	
  sleep 5
  
  # Create BP Server Service
  #-------------------------
  #sc.exe create "Blueprism Prod Server" binPath= "C:\Program Files\Blue Prism Limited\Blue Prism Automate\BPServerService.exe default" start= auto 
  #sleep 2
  #sc.exe stop "Blueprism Prod Server"
  #sleep 1
  #sc.exe start "Blueprism Prod Server"

  # Update default BP Server Service to auto start
  #-----------------------------------------------
  sc.exe config "Blue Prism Server" start= auto
  sleep 1
  sc.exe stop "Blue Prism Server"
  sleep 1
  sc.exe start "Blue Prism Server"

  # Install Telnet for debugging just in case
  #------------------------------------------
  #dism /online /Enable-Feature /FeatureName:TelnetClient
  
  # Execute Custom powershell code provided by user
  #------------------------------------------------
  ${custom_powershell_commands}

  # Rename Windows Hostname based on the resource type
  #---------------------------------------------------
  $hostname = '${win_hostname}'
  $domainname = '${dns_suffix_domain_name}'

  netdom computername $env:COMPUTERNAME /add:"$hostname.$domainname"
  netdom computername $env:COMPUTERNAME /makeprimary:"$hostname.$domainname" 
  netdom renamecomputer $env:COMPUTERNAME /newname:$hostname /force /reboot:0
</powershell>