Class _RHELCentOS
{
    [Object]            $Host
    [Object]            $Info       
    [Object]           $Tools      
    Hidden [Object] $Services_ = (systemctl list-units --type=service)
    [Object]        $Services   
    [Object]       $Processes
    [Object]         $Network
    [Object]         $Control    

    _RHELCentOS()
    {
        $This.Host       = [_UnixHost]::New()
        $This.Services   = [_UnixServices]::New()
        $This.Processes  = (Get-Process)
        $This.Network    = [_UnixNetwork]::New()
    }
}
