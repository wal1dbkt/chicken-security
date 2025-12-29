Write-Host "=== Windows: attente interfaces réseau ==="
Start-Sleep -Seconds 10

# Choisir la carte "host-only" = UP et SANS gateway IPv4
$adapter = Get-NetAdapter |
  Where-Object { $_.Status -eq "Up" } |
  Where-Object {
    $cfg = Get-NetIPConfiguration -InterfaceIndex $_.InterfaceIndex
    -not $cfg.IPv4DefaultGateway
  } |
  Select-Object -First 1

if (-not $adapter) {
  Write-Error "Aucune interface Host-Only trouvée (sans gateway)."
  exit 1
}

Write-Host "Interface sélectionnée: $($adapter.Name) (Index=$($adapter.InterfaceIndex))"

# Nettoyer IP v4 existantes sur cette interface (APIPA / anciennes IP)
Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue |
  Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

# Assigner l'IP statique attendue
New-NetIPAddress `
  -InterfaceIndex $adapter.InterfaceIndex `
  -IPAddress "192.168.56.30" `
  -PrefixLength 24

Write-Host "=== Activation WinRM ==="
winrm quickconfig -q
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

Write-Host "=== Firewall WinRM 5985 ==="
# Ouvre 5985 (au cas où la règle par défaut n'existe pas)
netsh advfirewall firewall add rule name="WinRM HTTP" dir=in action=allow protocol=TCP localport=5985 | Out-Null

Set-Service WinRM -StartupType Automatic
Start-Service WinRM

Write-Host "=== OK: IP 192.168.56.30 + WinRM prêt ==="
