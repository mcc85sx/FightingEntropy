Class _Root
{
    Hidden [String[]]     $Names = ("Name Version Provider Date Path Status" -Split " ") 
    [String]               $Name
    [String]            $Version
    [String]           $Provider
    [String]               $Date
    [String]               $Path
    [String]             $Status

    _Root([String]$Registry,[String]$Name,[String]$Version,[String]$Provider,[String]$Path)
    {
        $This.Name               = $Name
        $This.Version            = $Version
        $This.Provider           = $Provider
        $This.Date               = Get-Date -UFormat %Y_%m%d-%H%M%S
        $This.Path               = $Path
        $This.Status             = "Initialized"
        $This.Names              | % { Set-ItemProperty -Path $Registry -Name $_ -Value $This.($_) -Verbose }
    }
}
