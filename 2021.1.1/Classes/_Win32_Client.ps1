Class _Win32_Client
{
    [String]                $Name = [Environment]::MachineName.ToLower()
    [String]                 $DNS
    [String]             $NetBIOS = [Environment]::UserDomainName.ToLower()

    [String]            $Hostname
    [String]            $Username = [Environment]::UserName
    [Object]           $Principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    [Bool]               $IsAdmin
    [Object]             $Network

    [Object]             $PSDrive
    [Object]             $Profile
    Hidden [String[]]      $Tools = ("ViperBomb Chocolatey MDT WinPE WinADK WDS IIS/BITS ASP.Net DNS DHCP ADDS" -Split " ")
    [Object]                $Tool
    [Object]             $Feature
    [Object]             $Service
    [Object]             $Process

    _Win32_Client()
    {
        $This.DNS                 = @($Env:UserDNSDomain,"-")[!$env:USERDNSDOMAIN]
        $This.Hostname            = @($This.Name;"{0}.{1}" -f $This.Name, $This.DNS)[(Get-CimInstance Win32_ComputerSystem).PartOfDomain].ToLower()
        $This.IsAdmin             = $This.Principal.IsInRole("Administrator") -or $This.Principal.IsInRole("Administrators")
        
        If ( $This.IsAdmin -eq 0 )
        {
            Throw "Must run as administrator"
        }
    }
    
    GetServices()
    {
        $This.Services  = (Get-FEService)
    }
    
    GetProcesses()
    {
        $This.Processes = (Get-Process)
    }
    
    GetNetwork()
    {
        $This.Network   = (Get-FENetwork)
    }
}
