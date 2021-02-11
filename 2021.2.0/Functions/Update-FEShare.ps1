Function Update-FEShare
{
    [CmdLetBinding()]Param(
    [Parameter(Mandatory)][String]$ShareName,
    [ValidateSet(0,1,2)]
    [Parameter()][UInt32]$Mode)

    Class _BootImage
    {
        [Object] $Path
        [Object] $Name
        [Object] $Type
        [Object] $ISO
        [Object] $WIM
        [Object] $XML

        _BootImage([String]$Path,[String]$Name)
        {
            $This.Path = $Path
            $This.Name = $Name
            $This.Type = Switch ([UInt32]($This.Name -match "\(x64\)")) { 0 { "x86" } 1 { "x64" } }
            $Regex     = "($($This.Name -Replace "\(","\(" -Replace "\)","\)"))"

            ForEach ( $Item in ( Get-ChildItem $Path | ? Name -match $Regex ) )
            { 
                Switch($Item.Extension)
                {
                    .iso { $This.ISO = $Item }
                    .wim { $This.WIM = $Item }
                    .xml { $This.XML = $Item }
                }
            }
        }
    }

    Class _BootImages
    {
        [Object] $Images

        _BootImages([Object]$Directory)
        {
            $This.Images = @( )

            ForEach ( $Item in Get-ChildItem $Directory | ? Extension | % BaseName | Select-Object -Unique )
            {
                $This.Images += [_BootImage]::New($Directory,$Item)
            }
        }
    }

    # Load MDT(Module)
    Import-Module (Get-MDTModule)

    # Load FEShare(SMBShare)
    $Share = Get-FEShare -Name $ShareName

    If (!($Share))
    {
        Throw "Specified share was not detected"
    }

    # Load FEShare(PSDrive)
    New-PSDrive -Name $Share.Label -PSProvider MDTProvider -Root $Share.Path -Description $Share.Description

    # Update FEShare(MDT)
    Switch($Mode)
    {
        0 
        {  
            Update-MDTDeploymentShare -Path "$($Share.Label):\" -Force -Verbose
        }
    }

    # Update/Flush FEShare(Images)
    $ImageLabel = Get-ItemProperty -Path "$($Share.Label):\" | % { 

        @{  64 = $_.'Boot.x64.LiteTouchWIMDescription'
            86 = $_.'Boot.x86.LiteTouchWIMDescription' }
    }

    Get-ChildItem -Path "$($Share.Path)\Boot" | ? Extension | % { 

        $Label          = $ImageLabel[$(Switch -Regex ($_.Name) { 64 {64} 86 {86}})]
        $Image          = @{ 

            Path        = $_.FullName
            Name        = $_.Name
            NewName     = "{0}\{1}{2}" -f $_.Directory,$Label,$_.Extension
            Extension   = $_.Extension
        }

        If ( $Image.Name -match "LiteTouchPE_" )
        {
            If ( Test-Path $Image.NewName )
            {
                Remove-Item -Path $Image.NewName -Force -Verbose
            }

            $Image | % { Rename-Item -Path $_.Path -NewName "$Label$($_.Extension)" }
        }
    }

    # Service Running..?
    If (!(Get-Service | ? Name -eq WDSServer))
    {
        Throw "WDS Server not installed"
    }

    # Update/Flush FEShare(WDS)
    ForEach ( $Image in [_BootImages]::New("$($Share.Path)\Boot").Images )
    {        
        If (Get-WdsBootImage -Architecture $Image.Type -ImageName $Image.Name )
        {
            Write-Theme "Detected [!] ($($Image.Name)), removing..." 12,4,15,0
            Remove-WDSBootImage -Architecture $Image.Type -ImageName $Image
        }

        Write-Theme "Importing [~] ($($Image.Name))" 10,11,15,0
        Import-WdsBootImage -Path $Image.Wim.FullName -NewDescription $Image.Name
    }

    Restart-Service -Name WDSServer
}
