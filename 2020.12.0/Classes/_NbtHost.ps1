Class _NbtHost
{
    Hidden [String]    $Line
    [String]           $Name
    [String]             $ID
    [String]           $Type
    [String]        $Service

    _NbtHost([Object]$NBT,[String]$Line)
    {
        $This.Line    = $Line -Split " " | ? Length -gt 0
        $This.Name    = $Line[0]
        $This.ID      = $Line[1]
        $This.Type    = $Line[2]
        $This.Service = $NBT | ? { $_.ID -match $This.ID -and $_.Type -Match $This.Type } | % Service
    }
}
