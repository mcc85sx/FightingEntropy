Class _Source
{
    [String] $NetworkPath
    [String] $Branding
    [String] $Certificates
    [String] $Tools
    [String] $Snapshots
    [String] $Profiles

    _Source([String]$NetworkPath)
    {
        $This.NetworkPath   = "$NetworkPath"
        $This.Branding      = "$NetworkPath\[0]Branding"
        $This.Certificates  = "$NetworkPath\[1]Certificates"
        $This.Tools         = "$NetworkPath\[2]Tools"
        $This.Snapshots     = "$NetworkPath\[3]Snapshots"
        $This.Profiles      = "$NetworkPath\[4]Profiles"
    }
}
