Class _FEDCPromoText
{
    [String]                  $Name
    [Bool]               $IsEnabled
    [String]                  $Text

    _FEDCPromoText([String]$Name,[Bool]$IsEnabled)
    {
        $This.Name      = $Name
        $This.IsEnabled = $IsEnabled
        $This.Text      = ""
    }
}
