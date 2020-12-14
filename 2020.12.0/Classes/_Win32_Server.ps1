Class _Win32_Server
{
    [Object] $Host
    [Object] $Info
    [Object] $Tools
    [Object] $Services
    [Object] $Processes
    [Object] $Network
    [Object] $Control

    _Win32_Server()
    {
        $This.Host      = [_Host]::New()
        $This.Info      = [_Info]::New()
        $This.Tools     = ("ViperBomb Chocolatey MDT WinPE WinADK WDS IIS/BITS ASP.Net DNS DHCP ADDS" -Split " ")
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
        $This.Network   = [_Network]::New()
    }
}
