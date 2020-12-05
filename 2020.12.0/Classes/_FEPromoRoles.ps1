Class _FEPromoRoles
{
    [String] $Name
    [Bool]   $IsEnabled
    [Bool]   $IsChecked

    _FEPromoRoles([String]$Name,[Bool]$IsEnabled,[Bool]$IsChecked)
    {
        $This.Name      = $Name
        $This.IsEnabled = $IsEnabled
        $This.IsChecked = $IsChecked
    }
}
