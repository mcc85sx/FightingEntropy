Function Get-FEUser
{
    [CmdLetBinding()]Param([Parameter()][String]$Profile = $env:UserProfile)

    Class _Profile
    {
        Hidden [String[]] $Names = ("Desktop Documents Downloads Music Pictures Videos" -Split " ")
        [String] $Username
        [String] $Path
        [Object] $Filter
        [Object] $FilterSize
        [Object] $Full
        [String] $FullSize
        [Object] $Difference

        _Profile([Object]$Profile)
        {
            $This.Username   = ($Profile -Split "\\")[-1]
            $This.Path       = $Profile
            $This.Filter     = Get-ChildItem $Profile | ? { $_.Name -in $This.Names -or $_.PSIsContainer -eq $False }
            $This.FilterSize = $This.GetSize(($This.Filter | Get-ChildItem -Recurse))
            $This.Full       = Get-ChildItem $Profile -Recurse
            $This.FullSize   = $This.GetSize($This.Full)
            $This.Difference = $This.FullSize.Split(" ")[0] - $This.FilterSize.Split(" ")[0]
        }

        [String] GetSize([Object]$Object)
        {
            Return @( $Object | Measure-Object -Property Length -Sum | % { "{0:n3}" -f ($_.Sum / 1GB) } )
        }

        [Object] GetFilter()
        {
            Return @( $This.Filter | Get-ChildItem -Recurse | Select Mode, LastWriteTime, Length, Name, Fullname )
        }

        [Object] GetFull()
        {
            Return @( $This.Full | Get-ChildItem -Recurse | Select Mode, LastWriteTime, Length, Name, Fullname )
        }
    }

    [_Profile]::New($Profile)
}
