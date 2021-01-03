Class _NbtHost
{
    Hidden [String[]]  $Line
    [String]           $Name
    [String]             $ID
    [String]           $Type
    [String]        $Service

    _NbtHost([Object]$NBT,[String]$Line)
    {
        $This.Line    = $Line.Split(" ") | ? Length -gt 0
        $This.Name    = $This.Line[0]
        $This.ID      = $This.Line[1]
        $This.Type    = $This.Line[2]
        $This.Service = $NBT | ? ID -match $This.ID | ? Type -Match $This.Type | % Service
    }
}
