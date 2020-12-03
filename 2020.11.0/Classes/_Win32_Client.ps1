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
        $This.Host      = [_Host]::New()
        $This.Info      = [_Info]::New()
        $This.Tools     = @("ViperBomb","Chocolatey")
        $This.Services  = (Get-Service)
        $This.Processes = (Get-Process)
    }
}
