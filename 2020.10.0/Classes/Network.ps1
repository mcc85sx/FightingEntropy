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
    [String]            $IPAddress
    [String]                $Class
    [Int32]                $Prefix
    Hidden [Object]         $Route
    [String]              $Network
    [String]              $Gateway
    Hidden [String[]]      $Subnet
    [String]            $Broadcast

    FEIPV4Network([Object]$Address)
    {
        If ( ! $Address )
        {
            Throw "Address Empty"
        }

        $This.IPAddress = $Address.IPAddress
        $This.Class     = @('N/A';@('A')*126;'Local';@('B')*64;@('C')*32;@('MC')*16;@('R')*15;'BC')[[Int32]$This.IPAddress.Split(".")[0]]
        $This.Prefix    = $Address.PrefixLength

        $This.Route     = Get-NetRoute -AddressFamily IPV4 | ? InterfaceIndex -eq $Address.InterfaceIndex
        $This.Network   = $This.Route | ? { ($_.DestinationPrefix -Split "/")[1] -match $This.Prefix } | % { ($_.DestinationPrefix -Split "/")[0] }
        $This.Gateway   = $This.Route | ? NextHop -ne 0.0.0.0 | % NextHop
        $This.Subnet    = $This.Route | ? DestinationPrefix -notin 255.255.255.255/32,224.0.0.0/4,0.0.0.0/0 | % DestinationPrefix | Sort-Object
        $This.Broadcast = ( $This.Subnet | % { ( $_ -Split "/" )[0] } )[-1]
    }
}

Class FEIPV6Network
{
    [String] $IPAddress
    [Int32]  $Prefix
    [String] $Link

    FEIPV6Network([Object]$Address)
    {
        $This.IPAddress = $Address
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
        $This.IPV4        = [FEIPV4Network]::New($Interface.IPV4Address)
        $This.IPV6        = [FEIPV6Network]::New($Interface.IPV6LinkLocalAddress)
        $This.DNS         = $Interface.DNSServer
    }
}
