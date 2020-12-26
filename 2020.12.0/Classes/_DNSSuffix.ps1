Class _DNSSuffix
{
    [UInt32] $IsDomain     = ([WMIClass]"\\.\ROOT\CIMV2:Win32_ComputerSystem" | % GetInstances | % PartOfDomain)
    [String] $ComputerName
    [String] $Domain
    [String] $NVDomain
    [UInt32] $Sync

    _DNSSuffix()
    {
        Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters" | % { 

            $This.ComputerName = $_.HostName
            $This.Domain       = $_.Domain
            $This.NVDomain     = $_.'NV Domain'
            $This.Sync         = $_.SyncDomainWithMembership
        }
    }
}
