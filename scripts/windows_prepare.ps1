$UserName = "ansible"
$Password = ConvertTo-SecureString "Azerty,123" -AsPlainText -Force

if (-Not (Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue)) {
    New-LocalUser -Name $UserName -Password $Password -FullName "Ansible User" -Description "User for Ansible automation"
    Add-LocalGroupMember -Group "Administrators" -Member $UserName
}

winrm quickconfig -q
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

if (-Not (Get-NetFirewallRule -DisplayName "WinRM HTTP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name "WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5985
}

Enable-PSRemoting -Force
Test-WSMan -ComputerName localhost
