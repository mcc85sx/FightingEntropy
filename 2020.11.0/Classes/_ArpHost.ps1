Class _ArpHost
{
    Hidden [String] $Line
    [String] $Host
    [String] $IPAddress
    [String] $MacAddress
    [String] $Type

    [String] X ([Int32]$Start,[Int32]$End)
    {
        Return @( $This.Line.Substring($Start,$End).Trim(" ") )
    }

    _ArpHost([String]$Line)
    {
        $This.Line       = $Line
        $This.IPAddress  = $This.X(0,24)
        $This.MacAddress = $This.X(24,17)
        $This.Type       = $This.Line.Substring(41).Trim(" ")
    }
}
