    Class _Section
    {
        [String] $Xaml
        [String] $Name
        [UInt32] $Slot
        [String[]] $Names

        _Section([UInt32]$Slot,[String]$Xaml)
        {
            If ( $Slot -notin 0..9 )
            {
                Throw "Invalid Entry"
            }

            $This.Slot = $Slot
            $This.Name = Switch([UInt32]$Slot)
            {
                0 { 'UID' }
                1 { 'Client' }
                2 { 'Service' }
                3 { 'Device' }
                4 { 'Issue' }
                5 { 'Inventory' }
                6 { 'Purchase' }
                7 { 'Expense' }
                8 { 'Account' }
                9 { 'Invoice' }
            }

            $This.Xaml  = $Xaml
            $This.Names = [Regex]::Matches($Xaml,"((Name)\s*=\s*('|`")\w+('|`"))").value -ireplace "(Name=\`")" ,"" | % TrimEnd "`""
        }
    }
