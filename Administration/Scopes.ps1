$Zone     = "securedigitsplus.com"
$ScopeID  = Get-DhcpServerv4Scope | % ScopeID
$ID       = "mail"
$Template = @(Get-ADComputer -Filter * | ? Name -match template)
$VMSwitch = Get-VMSwitch | ? SwitchType -eq External | % Name
$VMC      = Get-VMHost
$DHCP     = Get-DhcpServerv4Lease -ScopeId $ScopeID | ? Hostname -match $ID
$DNS4     = Get-DNSServerResourceRecord -RRType A -ZoneName $Zone | ? HostName -match $ID
$DNS6     = Get-DNSServerResourceRecord -RRType AAAA -ZoneName $Zone | ? HostName -match $ID
$ADDS     = Get-ADObject -Filter * | ? Name -match $ID
$VM       = Get-VM | ? Name -match $ID

If ($DHCP.Count -gt 0)
{
    $DHCP | Remove-DHCPServerV4Lease -Verbose
}

If ($DNS4.Count -gt 0)
{
    $DNS4 | Remove-DnsServerResourceRecord -ZoneName $Zone -Force
}

If ($DNS6.Count -gt 0)
{
    $DNS6 | Remove-DnsServerResourceRecord -ZoneName $Zone -Force -Verbose
}

If ($ADDS.Count -gt 0)
{
    $ADDS | Remove-ADObject -Recursive -Confirm
}

If ($VM.Count -gt 0)
{
    ForEach ( $VMX in $VM )
    {
        If ( $VMX.State -eq "Running" )
        {
            Stop-VM -Name $VMX.Name -Force
        }
        $VMX.HardDrives.Path | Remove-Item -Force -Verbose
        $VMX | Remove-VM -Force -Verbose
    }
}
