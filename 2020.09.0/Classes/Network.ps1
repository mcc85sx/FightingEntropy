    Class FEVendorList
    {
        [Int32[]]       $Index
        [Int32[]]        $List
        [String[]]       $Name

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
                    Name.txt  { $This.Name  = Get-Content $Item.FullName }
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
        [Object[]]         $Adapter
        [Object[]]       $Interface

        FENetwork([String]$Path)
        {
            If ( ! ( Test-Path $Path ) )
            {
                Throw "Invalid Path"
            }

            $This.Path       = $Path
            $This.Archive    = Get-ChildItem -Path $Path -Filter Vendor.zip -Recurse | % FullName
            $This.VendorList = [FEVendorList]::New($This.Path)
            $This.Interface  = @( )
            Get-NetIPConfiguration -Detailed | % { $This.Interface += $_ }
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

        FEIPV4Network( )
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
            $Interface            | % { 

                $This.Name        = $_.ComputerName
                $This.Alias       = $_.InterfaceAlias
                $This.Index       = $_.InterfaceIndex
                $This.Description = $_.InterfaceDescription
                $This.MacAddress  = $_.NetAdapter.LinkLayerAddress
                $This.IPV4        = [FEIPV4Network]::New()
                $This.IPV6        = [FEIPV6Network]::New()
                $This.DNS         = $_.DNSServer
            }
        }
    }
