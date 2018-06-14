<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
</script>
<powershell>
  Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In;Enable-NetFirewallRule -Name FPS-ICMP6-ERQ-In

  # Allow incoming remote connection using WinRM
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow

  # Allow incoming connection to port 8181
  netsh advfirewall firewall add rule name="Open Port 8181" dir=in action=allow protocol=TCP localport=8181

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
  $newpath = "$oldpath;C:\Program Files\1Blue Prism Limited\Blue Prism Automate" 
  Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath 
  $env:Path += ";C:\Program Files\Blue Prism Limited\Blue Prism Automate" 
  
  # Download Blue Prism installer file 
  #----------------------------------- 
  iwr -Uri "${blueprism_installer_path}" -OutFile blueprism.msi 

  # Install Blue Prism Executable 
  #------------------------------ 
  msiexec.exe /i blueprism.msi /qb- ALLUSERS=1 

  sleep 20

  # Configure Appserver Connection with Blue Prism 
  #-----------------------------------------------
  Automate.exe /dbconname "default" /setbpserver "${appserver_hostname}" "${appserver_port}" /connectionmode 5

  sleep 10

  # Install Blue Prism Login Agent if the installer path is provided 
  #----------------------------------------------------------------- 
  ${install_login_agent}

  # Install Blue Prism MAPI Ex if the installer path is provided 
  #------------------------------------------------------------- 
  ${install_mapi}

  # Create script to start Resource listener on Desktop
  #---------------------------------------------------- 
  Set-Content -Path "C:\Users\Administrator\Desktop\resource.bat" -Value "automate.exe /resourcepc /public" -Force
  $WshShell = New-Object -comObject WScript.Shell

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
  netdom renamecomputer $env:COMPUTERNAME /newname:$hostname /force /reboot:15
</powershell>