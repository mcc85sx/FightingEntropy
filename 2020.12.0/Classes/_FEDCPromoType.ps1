Class _FEDCPromoType
{
    [String]                  $Name
    [Bool]               $IsEnabled
    [Object]                 $Value

    _FEPromoType([String]$Name,[Bool]$IsEnabled)
    {
        $This.Name      = $Name
        $This.IsEnabled = $IsEnabled
    }
}
