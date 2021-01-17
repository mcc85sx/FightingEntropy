Function Install-FEModule
{
    [CmdLetBinding()]
    Param(
    
    [ValidateSet("2021.1.0","2021.1.1")]
    [Parameter(Mandatory)]
    [String]$Version)

    $Install = @( )
    
    ForEach ( $Item in "OS Manifest RestObject Root Hive Install" -Split " " )
    {
        $Install += Invoke-RestMethod https://raw.githubusercontent.com/mcc85sx/FightingEntropy/master/$Version/Classes/_$Item.ps1
    }
    
    Invoke-Expression ( $Install -join "`n" )
    
    [_Install]::New($Version)
}

$Install = Install-FEModule -Version 2021.1.1
