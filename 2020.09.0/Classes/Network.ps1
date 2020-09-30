
    Class FEVendor
    {
        [String]       $Names
        [String]        $Name
        [String]         $Hex
        [Int32]        $Index
        [Int32]         $Rank

        FEVendor([Object]$Vendor,[String]$Mac)
        {
            If ( $Mac -notmatch "([A-Fa-f0-9]{2}(:|-)*){5}[A-Fa-f0-9]{2}" )
            {
                Throw "Invalid MacAddress"
            }

            $This.Hex     =  ( $Mac -Replace "(:|-)" , "" ).SubString(0,6)
            $This.Index   = Invoke-Expression "0x$($This.Hex)"

            $This.Rank    = 0
            $I            = 0

            While ( $This.Name -eq $Null )
            {
                $I ++
                $This.Rank = $This.Rank + $Vendor.List[$I]

                If ( $This.Rank -gt $This.Index )
                {
                    $This.Name = "Exceeded"
                }

                If ( $This.Rank -eq $This.Index )
                {
                    $This.Name = $Vendor.Names[$Vendor.Index[$I]]
                }
            }
        }
    }

    Class FEVendorList
    {
        [Int32[]]       $Index
        [Int32[]]        $List
        [String[]]      $Names

        FEVendorList([String]$Path)
        {
            If ( ! ( Test-Path $Path ) )
            {
                Throw "Invalid Path"
            }

            Expand-Archive -Path (Get-ChildItem -Path $Path -Filter Vendor.zip -Recurse | % FullName) -DestinationPath "$Path\Network" -Force

            ForEach ( $Item in Get-ChildItem -Path "$Path\Network" )
            {
                Switch ( $Item.Name )
                {
                    Index.txt { $This.Index = Get-Content $Item.FullName }
                    List.txt  { $This.List  = Get-Content $Item.FullName }
                    Name.txt  { $This.Names = Get-Content $Item.FullName }
                }

                Remove-Item -Path $Item.FullName
            }
        }
    }

    Class FENetwork
    {
        [String]              $Path
        [String]           $Archive
        [String]          $FilePath
        [Object]        $VendorList
        [Object[]]       $Interface

        FENetwork([String]$Path)
        {
            If ( ! ( Test-Path $Path ) )
            {
                Throw "Invalid Path"
            }

            $This.Path           = $Path
            $This.Archive        = Get-ChildItem -Path $Path -Filter Vendor.zip -Recurse | % FullName
            $This.FilePath       = "$Path\Network"
            $This.VendorList     = [FEVendorList]::New($This.Path)

            $This.Interface      = @( )
            ForEach ( $Interface in Get-NetIPConfiguration -Detailed )
            {
                $Item            = [FENetInterface]::New($Interface)
                $Item.Vendor     = [FEVendor]::New($This.VendorList,$Item.MacAddress)
                $This.Interface += $Item
            }

            $This.Interface      = $This.Interface | Sort-Object Index
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
        [Object] $Vendor
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
