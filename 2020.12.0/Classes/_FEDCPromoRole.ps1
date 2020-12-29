Class _FEDCPromoRole
{
    [String] $Name
    [Bool]   $IsEnabled
    [Bool]   $IsChecked

    _FEDCPromoRole([String]$Name,[Bool]$IsEnabled,[Bool]$IsChecked)
    {
        $This.Name      = $Name
        $This.IsEnabled = $IsEnabled
        $This.IsChecked = $IsChecked
    }
}
