Class _NbtHost
{
    Hidden [String]    $Line
    [String]           $Name
    [String]             $ID
    [String]           $Type
    [String]        $Service

    [String] X ([Int32]$Start,[Int32]$End)
    {
        Return @( $This.Line.Substring($Start,$End).TrimEnd(" ") )
    }

    _NbtHost([String]$Line)
    {
        $This.Line    = $Line
        $This.Name    = $This.X(0,19).TrimStart(" ")
        $This.ID      = $This.X(20,2)
        $This.Type    = $This.X(25,12)
    }
}
