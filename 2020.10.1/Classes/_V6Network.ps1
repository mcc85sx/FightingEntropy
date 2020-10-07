Class _V6Network
{
    [String] $IPAddress
    [Int32]  $Prefix
    [String] $Link

    _V6Network([Object]$Address)
    {
        $This.IPAddress = $Address
    }
}