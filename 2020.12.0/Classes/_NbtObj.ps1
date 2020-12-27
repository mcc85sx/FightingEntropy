Class _NbtObj
{
    [String]      $ID
    [String]    $Type
    [String] $Service

    _NbtObj([String]$In)
    {
        $This.ID, $This.Type, $This.Service = $In -Split "/"
    }
}
