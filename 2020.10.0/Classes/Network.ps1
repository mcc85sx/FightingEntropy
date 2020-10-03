
    Class VendorList
    {
        Hidden [Object]    $File
        [String[]]          $Hex
        [String[]]        $Names
        [String[]]         $Tags
        [Hashtable]          $ID
        [Hashtable]       $VenID

        VendorList([String]$Path)
        {
            Switch ([Int32]($Path -Match "(http|https)"))
            {
                0
                {
                    If ( ! ( Test-Path -Path $Path ) )
                    {
                        Throw "Invalid Path"
                    }
        
                    $This.File = (Get-Content -Path $Path) -join "`n"
                }

                1
                { 
                    [Net.ServicePointManager]::SecurityProtocol = 3072

                    $This.File = Invoke-RestMethod -URI $Path
                
                    If ( ! $This.File  )
                    {
                        Throw "Invalid URL"
                    }
                }
            }

            $This.Hex            = $This.File -Replace "(\t){1}.*","" -Split "`n"
            $This.Names          = $This.File -Replace "([A-F0-9]){6}\t","" -Split "`n"
            $This.Tags           = $This.Names | Sort-Object
            $This.ID             = @{ }

            ForEach ( $I in 0..( $This.Tags.Count - 1 ) )
            {
                If ( ! $This.ID[$This.Tags[$I]] )
                {
                    $This.ID.Add($This.Tags[$I],$I)
                }
            }

            $This.VenID          = @{ }
            ForEach ( $I in 0..( $This.Hex.Count - 1 ) )
            {
                $This.VenID.Add($This.Hex[$I],$This.Names[$I])
            }
        }
    }

    Class FENetwork
    {
        [Object]            $Vendor
        [Object[]]       $Interface

        FENetwork()
        {
            $This.Vendor         = [VendorList]::New("https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/VendorList.txt")
            $This.Interface      = @( )

            ForEach ( $Interface in Get-NetIPConfiguration -Detailed )
            {
                $Item            = [FENetInterface]::New($Interface)
                $Item.Vendor     = $This.GetVendor($Item.MacAddress)
                $This.Interface += $Item
            }

            $This.Interface      = $This.Interface | Sort-Object Index
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

    Class FEIPV4Network
    {
        [String] $IPAddress
        [Int32]  $Prefix
        [String] $Subnet
        [String] $Broadcast
        [String] $Network
        [Int32]  $Max

        FEIPV4Network()
        {

        }
    }

    Class FEIPV6Network
    {
        [String] $IPAddress
        [Int32]  $Prefix
        [String] $Link

        FEIPV6Network( )
        {

        }
    }

    Class FENetInterface
    {
        [String] $Name
        [String] $Alias
        [Int32]  $Index
        [String] $Description
        [String] $MacAddress
        [String] $Vendor
        [Object] $IPV4
        [Object] $IPV6
        [Object] $DNS

        FENetInterface([Object]$Interface)
        {
            $This.Name        = $Interface.ComputerName
            $This.Alias       = $Interface.InterfaceAlias
            $This.Index       = $Interface.InterfaceIndex
            $This.Description = $Interface.InterfaceDescription
            $This.MacAddress  = $Interface.NetAdapter.LinkLayerAddress
            $This.IPV4        = [FEIPV4Network]::New()
            $This.IPV6        = [FEIPV6Network]::New()
            $This.DNS         = $Interface.DNSServer
        }
    }