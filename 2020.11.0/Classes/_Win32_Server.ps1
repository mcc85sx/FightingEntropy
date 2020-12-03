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
        $This.Services  = (Get-Service)
        $This.Processes = (Get-Process)
        $This.Network   = [_Network]::new().Interface
    }
}
