Class _Network
{
    [Object]            $Vendor
    [Object[]]       $Interface

    _Network()
    {
        $This.Vendor         = [_VendorList]::New("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/VendorList.txt")
        $This.Interface      = @( )

        ForEach ( $Interface in Get-NetIPConfiguration -Detailed )
        {
            $Item            = [_NetInterface]::New($Interface)
            $Item.Vendor     = $This.GetVendor($Item.MacAddress)
            $This.Interface += $Item
        }

        $This.Interface      = $This.Interface | Sort-Object Index
    }

    [String] GetVendor([String]$MacAddress)
    {
        If ( $MacAddress -notmatch "([A-Fa-f0-9]{2}(-|:)*){5}[A-Fa-f0-9]{2}" )
        {
            Throw "Invalid MacAddress"
        }
            
        Return $This.Vendor.VenID[( $MacAddress -Replace "(:|-)" , "" ).SubString(0,6)]
    }
}