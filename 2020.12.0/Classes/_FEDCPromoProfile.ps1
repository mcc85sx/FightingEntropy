Class _FEDCPromoProfile
{
    [UInt32]           $Mode
    Hidden [Hashtable] $Hash = @{ 

        Slot  = "Forest Tree Child Clone" -Split " "
        Types = "ForestMode DomainMode DomainType ParentDomainName " -Split " "
        Names = "DomainName DomainNetBIOSName SiteName NewDomainName NewDomainNetBIOSName" -Split " "
        Roles = "InstallDns CreateDnsDelegation CriticalReplicationOnly NoGlobalCatalog" -Split " "
    }

    Hidden [Hashtable] $Grid = @{ 

        Types = ((0,1),(1..3),(1..3),(4))
        Names = ((0,1),(2..4),(2..4),(0,2))
        Roles = ((0,1),(0,1,3),(0,1,3),(0..3))
    }

    [String]           $Slot
    [Object[]]        $Types
    [Object[]]        $Names
    [Object[]]        $Roles

    _FEDCPromoProfile([UInt32]$Mode)
    {
        If ( $Mode -notin 0..3 )
        {
            Throw "Invalid Entry"
        }

        $This.Mode  = $Mode
        $This.Slot  = $This.Hash.Slot[$Mode]
        $This.Types = $This.Hash.Types[$This.Grid.Types[$Mode]]
        $This.Names = $This.Hash.Names[$This.Grid.Names[$Mode]]
        $This.Roles = $This.Hash.Roles[$This.Grid.Roles[$Mode]]
    }
}
