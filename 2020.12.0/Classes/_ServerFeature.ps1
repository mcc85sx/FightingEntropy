Class _ServerFeature
{
    [String] $Name
    [String] $DisplayName
    [Bool]   $Installed

    _ServerFeature([String]$Name,[String]$DisplayName,[Int32]$Installed)
    {
        $This.Name           = $Name
        $This.DisplayName    = $Displayname
        $This.Installed      = $Installed
    }
}
