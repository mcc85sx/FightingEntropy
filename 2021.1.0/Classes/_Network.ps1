    Class _Network
    {
        [Object[]]   $Adapter
        [Object]      $Vendor
        [Object[]]       $NBT
        [Object]     $NBTScan
        [Object]     $ARPScan
        [Object[]] $Interface

        _Network()
        {
            Write-Host "Collecting Network Adapters"
            $This.Adapter        = (Get-NetAdapter)

            Write-Host "Collecting Vendor List"
            $This.Vendor         = [_VendorList]::New("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/scratch/VendorList.txt")
            
            Write-Host "Scanning NBT Table"
            $This.NBT            = [_NBTRef]::New().Output
            $This.NBTScan        = [_NBTScan]::New().Output
            
            Write-Host "Scanning ARP Table"
            $This.ARPScan        = [_ARPScan]::New().Output
            $This.Interface      = @( )

            ForEach ( $Interface in Get-NetIPConfiguration -Detailed )
            {
                $Item            = [_NetInterface]::New($Interface)
                $Item.Vendor     = $This.GetVendor($Item.MacAddress)
                $Item.Arp        = $This.ARPScan | ? IFIndex -eq $Item.Index
                $Item.NBT        = $This.NBTScan | ? Name -eq $Item.Alias
                $This.Interface += $Item
                Write-Host ("[+] {0}" -f $Item.Alias)
            }

            $This.Interface      = $This.Interface | Sort-Object Alias
        }

        [String] GetVendor([String]$MacAddress)
        {
            If ( $MacAddress -notmatch "([A-Fa-f0-9]{2}(-|:)*){5}[A-Fa-f0-9]{2}" )
            {
                Throw "Invalid MacAddress"
            }
            
            Return $This.Vendor.VenID[( $MacAddress -Replace "(:|-)" , "" ).SubString(0,6)]
        }
    }
