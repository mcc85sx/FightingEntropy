Class _Images
{
    [String]          $Root = ("{0}\Images" -f ( Get-FEModule | % Path) )
    [String[]]        $Tree
    [String]         $Drive = ([Char]( [Int32]( Get-Volume | Sort-Object DriveLetter | % DriveLetter )[-1] + 1 ))

    Hidden [Hashtable] $Map = @{ 
        
        Names  = "{0} x64;{1} x64;{2} x64;{3} x64;{1} x86;{2} x86;{3} x86" -f ("Server 2016 Datacenter;10 Education;10 Home;10 Pro" -Split ";") -Split ";" | % { "Windows $_" }
        Paths  = "DC2016;10E64;10H64;10P64;10E86;10H86;10P86".Split(";")
        Indexs = 4 , 4 , 4 , 1 , 1 , 6 , 6
    }

    [Object]         $Files

    _Images()
    {
        $This.Tree  = @( )
        $This.Files = @( )

        Test-Path $This.Root | ? { $_ -eq $False } | New-Item $This.Root -ItemType Directory -Verbose

        ForEach ( $I in 0..( $This.Map.Names.Count - 1 ) )
        {
            ("{0}\{1}" -f $This.Root, $This.Map.Paths[$I]) | % { 
                
                If ( ! ( Test-Path $_ ) ) 
                {
                    New-Item $_ -ItemType Directory -Verbose
                }

                $This.Tree += $_
            }
        }

        $This.ExtractImages("Server","C:\Users\mcook85\Downloads\Windows Server 2016.iso")
        $This.ExtractImages("Client","C:\Users\mcook85\Downloads\Win10_20H2_English_x64.iso")
        $This.ExtractImages("Client","C:\Users\mcook85\Downloads\Win10_20H2_English_x32.iso")
    }

    ExtractImages([String]$Type,[String]$ISO)
    {
        If ( ! ( Test-Path $ISO ) )
        {
            Throw "Invalid image path"
        }

        If ( Get-Item $ISO | ? Extension -ne .iso )
        {
            Throw "Invalid image file"
        }

        If ( $Type -notin "Client","Server" )
        {
            Throw "Not a valid image type"
        }

        If ( $Type -eq "Server" )
        {
            Mount-DiskImage -ImagePath $ISO

            $Splat                   = @{

                SourceIndex          = 4
                SourceImagePath      = "$($This.Drive):\sources\Install.wim"
                DestinationImagePath = "$($This.Root)\DC2016\DC2016.wim"
                DestinationName      = $This.Map.Names[0]
            
            }
            
            Write-Theme @( "Extracting" ; $Splat )

            $Splat                   | % { Export-WindowsImage @_ -Verbose }

            Dismount-DiskImage -ImagePath $ISO -Verbose
        }
        
        If ( $Type -eq "Client" )
        {
            Mount-DiskImage -ImagePath $ISO

            $Arch        = @{ 0 = 86 ; 1 = 64 }[[Int32]($ISO -match "x64")]

            ForEach ( $I in 4,1,6 )
            {
                $Label       = "10{0}{1}" -f @{ 1 = "H"; 4 = "E"; 6 = "P" }[$I],$Arch

                $DisplayName = @{  
                    
                    "10E64"  = 1
                    "10H64"  = 2
                    "10P64"  = 3
                    "10E86"  = 4
                    "10H86"  = 5
                    "10P86"  = 6 
                
                }[$Label]    | % { $This.Map.Names[$_] }

                $Splat                   = @{

                    SourceIndex          = $I
                    SourceImagePath      = "$($This.Drive):\sources\Install.wim"
                    DestinationImagePath = "$($This.Root)\$Label\$Label.wim"
                    DestinationName      = $DisplayName
                
                }                        
                
                Write-Theme @( "Extracting" ; $Splat ) 
                $Splat                   | % { Export-WindowsImage @_ -Verbose }
            }

            Dismount-DiskImage -ImagePath $ISO -Verbose
        }
    }
}
