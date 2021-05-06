    Class _DGList
    {
        [String] $Name
        [Object] $Value

        _DGList([String]$Name,[Object]$Value)
        {
            $This.Name  = $Name
            $This.Value = $Value -join ", "
        }
    }
