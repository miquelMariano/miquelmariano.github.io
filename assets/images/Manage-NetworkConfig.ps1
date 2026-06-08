param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("save", "restore")]
    [string]$Action
)

$ConfigFile = "C:\migration-netcfg.json"
$LogFile    = "C:\migration-netcfg.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

if ($Action -eq "save") {

    Write-Log "=== INICIO: Guardando configuracion de red ==="

    $adapter = Get-NetAdapter | Where-Object {
        $_.Status -eq "Up" -and
        $_.InterfaceDescription -notlike "*Loopback*" -and
        $_.InterfaceDescription -notlike "*WAN Miniport*"
    } | Select-Object -First 1

    if (-not $adapter) { Write-Log "ERROR: No se encontro adaptador activo."; exit 1 }

    Write-Log "Adaptador detectado: $($adapter.Name) - $($adapter.InterfaceDescription)"

    $ipConfig  = Get-NetIPConfiguration -InterfaceIndex $adapter.InterfaceIndex
    $ipAddress = $ipConfig.IPv4Address | Select-Object -First 1
    $gateway   = $ipConfig.IPv4DefaultGateway | Select-Object -First 1
    $dns       = (Get-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -AddressFamily IPv4).ServerAddresses

    if (-not $ipAddress) { Write-Log "ERROR: Sin IP IPv4."; exit 1 }

    $data = @{
        IPAddress    = $ipAddress.IPAddress
        PrefixLength = [int]$ipAddress.PrefixLength
        Gateway      = if ($gateway) { $gateway.NextHop } else { "" }
        DNS          = @($dns)
    }

    $data | ConvertTo-Json | Out-File -FilePath $ConfigFile -Encoding UTF8 -Force

    Write-Log "IP guardada: $($data.IPAddress)/$($data.PrefixLength)"
    Write-Log "Gateway   : $($data.Gateway)"
    Write-Log "DNS       : $($data.DNS -join ', ')"
    Write-Log "=== FIN: Guardado correctamente en $ConfigFile ==="

} elseif ($Action -eq "restore") {

    Write-Log "=== INICIO: Restaurando configuracion de red ==="

    if (-not (Test-Path $ConfigFile)) { Write-Log "ERROR: No existe $ConfigFile"; exit 1 }

    $data = Get-Content $ConfigFile -Raw | ConvertFrom-Json

    Write-Log "Config leida - IP: $($data.IPAddress)/$($data.PrefixLength) GW: $($data.Gateway)"

    $virtio = Get-NetAdapter | Where-Object {
        $_.InterfaceDescription -like "*VirtIO*" -or
        $_.InterfaceDescription -like "*Red Hat*"
    } | Select-Object -First 1

    if (-not $virtio) { Write-Log "ERROR: No se encontro adaptador VirtIO."; exit 1 }

    Write-Log "Adaptador destino: $($virtio.Name) - $($virtio.InterfaceDescription)"

    Remove-NetIPAddress -InterfaceIndex $virtio.InterfaceIndex -Confirm:$false -ErrorAction SilentlyContinue
    Remove-NetRoute     -InterfaceIndex $virtio.InterfaceIndex -Confirm:$false -ErrorAction SilentlyContinue

    $params = @{
        InterfaceIndex = $virtio.InterfaceIndex
        IPAddress      = $data.IPAddress
        PrefixLength   = [int]$data.PrefixLength
        AddressFamily  = "IPv4"
    }
    if ($data.Gateway -ne "") { $params["DefaultGateway"] = $data.Gateway }

    New-NetIPAddress @params | Out-Null
    Write-Log "IP aplicada: $($data.IPAddress)"

    if ($data.DNS.Count -gt 0) {
        Set-DnsClientServerAddress -InterfaceIndex $virtio.InterfaceIndex -ServerAddresses $data.DNS
        Write-Log "DNS aplicado: $($data.DNS -join ', ')"
    }

    Start-Sleep -Seconds 2
    $verify = Get-NetIPConfiguration -InterfaceIndex $virtio.InterfaceIndex
    Write-Log "Verificacion: IP=$($verify.IPv4Address.IPAddress) GW=$($verify.IPv4DefaultGateway.NextHop)"
    Write-Log "=== FIN: Restauracion completada ==="
}
