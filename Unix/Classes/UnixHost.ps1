Class UnixHost
{
    Hidden [Object]         $Obj = (hostnamectl)
    Hidden [String[]]     $Order = ("Hostname HostID Chassis MachineID BootID VMProvider OS CPE Kernel Architecture" -Split " ") 
    [String]             $HostID
    [String]           $Hostname
    [String]            $Chassis
    [String]          $MachineID
    [String]             $BootID
    [String]         $VMProvider
    [String]                 $OS
    [String]                $CPE
    [String]             $Kernel
    [String]       $Architecture

    [String]                Item([String]$I)
    {
        $Item = ( $This.Obj | ? { $_ -cmatch $I } )

        Return @( If (!!$Item) {$Item.Substring(20)} Else {"-"} )
    }

    UnixHost()
    {
        $This.Hostname      = $This.Item("Static hostname")
        $This.HostID        = $This.Hostname.Split(".")[0]
        $This.Chassis       = $This.Item("Chassis")
        $This.MachineID     = $This.Item("Machine ID")
        $This.BootID        = $This.Item("Boot ID")
        $This.VMProvider    = $This.Item("Virtualization")
        $This.OS            = $This.Item("Operating System")
        $This.CPE           = $This.Item("CPE OS Name")
        $This.Kernel        = $This.Item("Kernel")
        $This.Architecture  = $This.Item("Architecture")
    }
}
