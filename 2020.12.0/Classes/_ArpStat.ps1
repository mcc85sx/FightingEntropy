    Class _ArpStat
    {
        Hidden [String] $Object
        [String] $Name
        [String] $IPAddress
        [String] $IFIndex
        [Object[]] $Hosts

        _ArpStat([Object]$Object)
        {
            $This.Object    = $Object
            $This.IPAddress = $Object[0].Replace("Interface: ","").Split(" ")[0]
            $This.IFIndex   = Invoke-Expression $Object[0].Split(" ")[-1]
            $This.Name      = (Get-NetIPInterface | ? IFIndex -eq $This.IFIndex | % IFAlias)[0]
            $This.Hosts     = $Object | ? { $_ -notmatch "(Interface|static)" } | % { [_ArpHost]::New($_) }
        }
    }
