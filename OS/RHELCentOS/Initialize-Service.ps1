Function Initialize-Service
{
    [CmdLetBinding()]Param( 
        [Parameter(Mandatory,Position=0)][String]$Name,
        [ValidateSet("Launch","Status","Restart")]
        [Parameter(Mandatory,Position=1)][String]$Mode)

    ForEach ( $Item in @( Switch($Mode) { Launch {0,1,2} Status {0,1,4} Restart {3} }))
    {
        systemctl ("start,enable,reload,restart,status" -Split ",")[$Item] $Name
    }
}
