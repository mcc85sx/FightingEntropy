Class Info
{
    [Object]                 $OS = (Get-CimInstance -ClassName Win32_OperatingSystem)
    [Object]                 $CS = (Get-CimInstance -ClassName Win32_ComputerSystem)
    Hidden [Object]         $Env = ([PSCustomObject][Environment]::GetEnvironmentVariables().GetEnumerator() | Sort-Object Name)

    Hidden [Hashtable]     $Hash = @{ 

                         Edition = ("10240,Threshold 1,Release To Manufacturing;10586,Threshold 2,November {1};14393,{0} 1,Anniversary {1};15063," + 
                                    "{0} 2,{2} {1};16299,{0} 3,Fall {2} {1};17134,{0} 4,April 2018 {1};17763,{0} 5,October 2018 {1};18362,19H1,Ma" + 
                                    "y 2019 {1};18363,19H2,November 2019 {1};19000,20H1,Unreleased") -f 'Redstone','Update','Creators' -Split ";"

                         Chassis = "N/A Desktop Mobile/Laptop Workstation Server Server Appliance Server Maximum" -Split " "
                             SKU = ("Undefined,Ultimate {0},Home Basic {0},Home Premium {0},{3} {0},Home Basic N {0},Business {0},Standard {2} {0" + 
                                    "},Datacenter {2} {0},Small Business {2} {0},{3} {2} {0},Starter {0},Datacenter {2} Core {0},Standard {2} Cor" +
                                    "e {0},{3} {2} Core {0},{3} {2} IA64 {0},Business N {0},Web {2} {0},Cluster {2} {0},Home {2} {0},Storage Expr" + 
                                    "ess {2} {0},Storage Standard {2} {0},Storage Workgroup {2} {0},Storage {3} {2} {0},{2} For Small Business {0" + 
                                    "},Small Business {2} Premium {0},TBD,{1} {3},{1} Ultimate,Web {2} Core,-,-,-,{2} Foundation,{1} Home {2},-,{" + 
                                    "1} {2} Standard No Hyper-V Full,{1} {2} Datacenter No Hyper-V Full,{1} {2} {3} No Hyper-V Full,{1} {2} Datac" + 
                                    "enter No Hyper-V Core,{1} {2} Standard No Hyper-V Core,{1} {2} {3} No Hyper-V Core,Microsoft Hyper-V {2},Sto" + 
                                    "rage {2} Express Core,Storage {2} Standard Core,{2} Workgroup Core,Storage {2} {3} Core,Starter N,Profession" + 
                                    "al,Professional N,{1} Small Business {2} 2011 Essentials,-,-,-,-,-,-,-,-,-,-,-,-,Small Business {2} Premium " + 
                                    "Core,{1} {2} Hyper Core V,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,--,-,-,{1} Thin PC,-,{1} Embedded Industry,-,-" +
                                    ",-,-,-,-,-,{1} RT,-,-,Single Language N,{1} Home,-,{1} Professional with Media Center,{1} Mobile,-,-,-,-,-,-" + 
                                    ",-,-,-,-,-,-,-,{1} Embedded Handheld,-,-,-,-,{1} IoT Core") -f "Edition","Windows","Server","Enterprise" -Split ","
    }

    Hidden [Object]      $VTable = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' )
    [String]            $Caption
    [Object]            $Version
    [String]              $Build
    [Int32]           $ReleaseID
    [String]           $CodeName
    [String]               $Name
    [String]                $SKU
    [String]            $Chassis

    Info()
    {
        $This.Version            = (Get-Host).Version.ToString()
        $This.ReleaseID          = $This.VTable.ReleaseID
        $ID                      = Switch ($This.ReleaseID) { 1507 {0} 1511 {1} 1607 {2} 1703 {3} 1709 {4} 1803 {5} 1809 {6} 1903 {7} 1909 {8} 2004 {9} }

        $This.Build, $This.CodeName, $This.Name = $This.Hash.Edition[$ID].Split(",")

        $This.Caption            = $This.OS.Caption
        $This.SKU                = $This.Hash.SKU[$This.OS.OperatingSystemSKU]
        $This.Chassis            = $This.Hash.Chassis[$This.CS.PCSystemType]
    }
}

Class File
{
    [String]                $Mode
    [DateTime]              $Date
    [Int32]                $Depth
    [String]                $Name
    [String]            $FullName
    [Object]            $Provider

    File([String]$Path)
    {
        [System.IO.FileInfo]::New($Path) | % {

            $This.Mode            = $_.Mode
            $This.Date            = $_.LastWriteTime
            $This.Depth           = $_.FullName.Split("\").Count - 2
            $This.Name            = $_.Name
            $This.FullName        = $_.FullName
            $This.Provider        = $Provider
        }
    }
}

Class Drive
{
    [Object]                $Name
    Hidden [String] $FullProvider
    [String]            $Provider
    [String]                $Root
    [String]         $DisplayRoot
    [String]         $Description
    Hidden [Int32]          $Mode
    
    Drive([Object]$Drive)
    {
        $This.Name                = $Drive.Name
        $This.FullProvider        = $Drive.Provider
        $This.Provider            = Split-Path -Leaf $Drive.Provider
        $This.Root                = $Drive.Root
        $This.DisplayRoot         = $Drive.DisplayRoot
        $This.Description         = $Drive.Description | % { ($_,"-")[!$_] }
        $This.Mode                = Switch ( Split-Path -Leaf $Drive.Provider )
        { 
            FileSystem   {0} Certificate  {1} Environment  {2} Registry     {3} Temp         {4} 
            Alias        {5} Function     {6} Variable     {7} WSMan        {8} Default     {-1} 
        }
    }
}
    
Class Drives
{
    [Drive[]]           $PSDrives
    [Drive[]]         $FileSystem
    [Drive[]]            $Network
    [Drive[]]          $CertStore
    [Object[]]             $Samba
        
    Drives()
    {
        $This.PSDrives            = Get-PSDrive      | % { [Drive]::New($_) } | Sort-Object Mode
        $This.FileSystem          = $This.PSDrives   | ? Mode -eq 0 | Sort-Object Root 
        $This.Network             = $This.FileSystem | ? DisplayRoot
        $This.CertStore           = $This.PSDrives   | ? Mode -eq 1
        $This.Samba               = Get-SMBShare     | Sort-Object Path
    }
}
