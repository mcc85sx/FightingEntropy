Class _NbtHost
{
    Hidden [String]    $Line
    [String]           $Name
    [String]             $ID
    [String]           $Type
    [String]        $Service

    _NbtHost([Object]$NBT,[String]$Line)
    {
        $This.Line    = $Line
        $This.Name    = $Line.Substring(0,19).TrimStart(" ")
        $This.ID      = $Line.Substring(20,2)
        $This.Type    = $Line.Substring(25,12)
        $This.Service = $NBT | ? { $_.ID -match $This.ID -and $_.Type -Match $This.Type } | % Service
    }
}
