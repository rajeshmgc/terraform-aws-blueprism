<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
</script>
<powershell>
  Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In;Enable-NetFirewallRule -Name FPS-ICMP6-ERQ-In

  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow

  # Set Administrator password
  $Admin = [adsi]("WinNT://./administrator, user")
  $Admin.psbase.invoke("SetPassword", "${administrator_password}")

  # Create new custom user
  $Password = ConvertTo-SecureString "${custom_user_password}" –AsPlainText –Force
  New-LocalUser "${custom_user_username}" -Password $Password -PasswordNeverExpires -AccountNeverExpires -FullName "${custom_user_username}" -Description "${custom_user_username}"

  # Give Administrator rights to new custom user
  Add-LocalGroupMember -Group "Administrators" -Member "${custom_user_username}"
</powershell>