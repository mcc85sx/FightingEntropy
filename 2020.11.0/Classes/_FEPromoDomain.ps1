Class _FEPromoDomain
{
    [String] $Name
    [Bool]   $IsEnabled
    [String] $Text

    _FEPromoDomain([String]$Name,[Bool]$IsEnabled)
    {
        $This.Name      = $Name
        $This.IsEnabled = $IsEnabled
        $This.Text      = ""
    }
}
