Class _Win32_Client
{
    [Object] $Host
    [Object] $Info
    [Object] $Tools
    [Object] $Services
    [Object] $Processes
    [Object] $Network
    [Object] $Control

    _Win32_Client()
    {
        $This.Host      = (Get-FEHost)
        $This.Info      = [_Info]::New()
        $This.Tools     = @("ViperBomb","Chocolatey")
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
