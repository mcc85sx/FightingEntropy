Class _FEDCPromoProfile
{
    [UInt32]              $Mode
    Hidden [Hashtable]    $Tags = @{ 

        Slot                    = "Forest Tree Child Clone" -Split " "
        Type                    = "ForestMode DomainMode DomainType" -Split " "
        Text                    = "Parent{0} {0} Domain{1} SiteName New{0} NewDomain{1}" -f "DomainName","NetBIOSName" -Split " "
        Role                    = "InstallDns CreateDnsDelegation CriticalReplicationOnly NoGlobalCatalog" -Split " "
    }

    [Object]              $Slot
    [Object]              $Type
    [Object]              $Text
    [Object]              $Role

    _FEDCPromoProfile([UInt32]$Mode)
    {
        If ( $Mode -notin 0..3 )
        {
            Throw "Invalid Entry"
        }

        $This.Mode              = $Mode
        $This.Slot              = $This.Tags.Slot[$Mode]
        $This.Type              = $This.Tags.Type | % { $This.GetFEDCPromoType($Mode,$_) }
        $This.Text              = $This.Tags.Text | % { $This.GetFEDCPromoText($Mode,$_) }
        $This.Role              = $This.Tags.Role | % { $This.GetFEDCPromoRole($Mode,$_) }
    }

    [Object] GetFEDCPromoType([UInt32]$Mode,[String]$Type)
    {
        $Item                   = Switch($Type)
        {
            ForestMode            {1,0,0,0}
            DomainMode            {1,1,1,0}
            DomainType            {0,1,1,0}
        }

        Return @([_FEDCPromoType]::New($Type,$Item[$Mode]) )
    }

    [Object] GetFEDCPromoText([UInt32]$Mode,[String]$Type)
    {
        $Item                   = Switch($Type)
        {
            ParentDomainName      {0,1,1,0}
	        DomainName            {1,0,0,1}
	        DomainNetbiosName     {1,0,0,0}
	        SiteName              {0,1,1,1}
	        NewDomainName         {0,1,1,0}
	        NewDomainNetbiosName  {0,1,1,0}
        }

        Return @([_FEDCPromoText]::New($Type,$Item[$Mode]))
    }

    [Object] GetFEDCPromoRole([UInt32]$Mode,[String]$Type)
    {
        $Item                   = Switch($Type)
        {
            InstallDNS              {(1,1,1,1),(1,1,1,1)}
            CreateDNSDelegation     {(1,1,1,1),(0,0,1,0)}
            NoGlobalCatalog         {(0,1,1,1),(0,0,0,0)}
            CriticalReplicationOnly {(0,0,0,1),(0,0,0,0)}
        }

        Return @([_FEDCPromoRole]::New($Type,$Item[0][$Mode],$Item[1][$Mode]))
    }
}
