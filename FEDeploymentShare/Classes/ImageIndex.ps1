Class ImageIndex
{
    Hidden [UInt32] $Rank
    Hidden [UInt32] $SourceIndex
    Hidden [String] $SourceImagePath
    Hidden [String] $Path
    Hidden [String] $DestinationImagePath
    Hidden [String] $DestinationName
    Hidden [Object] $Disk
    [Object] $Label
    [UInt32] $ImageIndex            = 1
    [String] $ImageName
    [String] $ImageDescription
    [String] $Version
    [String] $Architecture
    [String] $InstallationType
    ImageIndex([Object]$Iso)
    {
        $This.SourceIndex           = $Iso.SourceIndex
        $This.SourceImagePath       = $Iso.SourceImagePath
        $This.DestinationImagePath  = $Iso.DestinationImagePath
        $This.DestinationName       = $Iso.DestinationName
        $This.Disk                  = Get-DiskImage -ImagePath $This.SourceImagePath
    }
    Load([String]$Target)
    {
        Get-WindowsImage -ImagePath $This.Path -Index $This.SourceIndex | % {

            $This.ImageName         = $_.ImageName
            $This.ImageDescription  = $_.ImageDescription
            $This.Architecture      = Switch ([UInt32]($_.Architecture -eq 9)) { 0 { 86 } 1 { 64 } }
            $This.Version           = $_.Version
            $This.InstallationType  = $_.InstallationType.Split(" ")[0]
        }

        Switch($This.InstallationType)
        {
            Server
            {
                $Year    = [Regex]::Matches($This.ImageName,"(\d{4})").Value
                $Edition = Switch -Regex ($This.ImageName) { STANDARD { "Standard" } DATACENTER { "Datacenter" } }
                $This.DestinationName = "Windows Server $Year $Edition (x64)"
                $This.Label           = "{0}{1}" -f $(Switch -Regex ($This.ImageName){Standard{"SD"}Datacenter{"DC"}}),[Regex]::Matches($This.ImageName,"(\d{4})").Value
            }

            Client
            {
                $This.DestinationName = "{0} (x{1})" -f $This.ImageName, $This.Architecture
                $This.Label           = "10{0}{1}"   -f $(Switch -Regex ($This.ImageName) { Pro {"P"} Edu {"E"} Home {"H"} }),$This.Architecture
            }
        }

        $This.DestinationImagePath    = "{0}\({1}){2}\{2}.wim" -f $Target,$This.Rank,$This.Label

        $Folder                       = $This.DestinationImagePath | Split-Path -Parent

        If (!(Test-Path $Folder))
        {
            New-Item -Path $Folder -ItemType Directory -Verbose
        }
    }
}