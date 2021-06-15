Function _Content
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,Position=0)][String]$Path,
        [Parameter(Mandatory,Position=1)][String]$Search,
        [Parameter(Mandatory,Position=2)][String]$Replace)

    If (!(Test-Path $Path))
    {
        Throw "Invalid path"
    }

    $Content = ( Get-Content $Path ) -Replace $Search,$Replace
    
    Set-Content -Path $Path -Value $Content -Verbose
}
