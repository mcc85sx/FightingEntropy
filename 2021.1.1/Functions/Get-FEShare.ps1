Function Get-FEShare
{
    [CmdletBinding()]
    Param(
    [Parameter()][String]$Name,
    [Parameter()][String]$Path)

    Class _Share
    {
        [String] $Hostname
        [String] $Label
        [String] $Name
        [String] $ScopeName
        [String] $Path
        [String] $NetworkPath
        [String] $Description

        _Share([Object]$Persist)
        {
            $This.Hostname    = [Environment]::MachineName
            $This.Label       = $Persist.Name
            $This.Path        = $Persist.Path
            $This.Description = $Persist.Description
        }

        Load([Object]$Share)
        {
            $This.Name        = $Share.Name
            $This.ScopeName   = $Share.ScopeName
            $This.NetworkPath = "\\{0}\{1}$" -f $This.Hostname,$This.Name.TrimEnd("$")
        }
    }

    Import-Module (Get-MDTModule)

    [Object] $Persist = @( )
    [Object] $Return  = @( )

    ForEach ( $xDrive in Get-MDTPersistentDrive | % { [_Share]::New($_) } )
    {
        Get-SMBShare | ? Path -eq $xDrive.Path | % { $xDrive.Load($_) }

        $Persist += $xDrive
    }

    ForEach ( $xDrive in $Persist )
    { 
        If ( ! ( Get-PSDrive | ? Name -eq $xDrive.Label ) )
        {
            $Splat          = @{  
                
                Name        = $xDrive.Label 
                PSProvider  = "MDTProvider"
                Root        = $xDrive.Path 
                Description = $xDrive.Description 
                NetworkPath = $xDrive.NetworkPath
            } 
            
            New-PSDrive @Splat -Verbose
        }

        $Return            += $xDrive
    }

    $Return
}
