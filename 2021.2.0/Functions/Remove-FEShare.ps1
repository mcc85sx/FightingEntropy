Function Remove-FEShare
{
    [CmdLetBinding()]Param([Parameter(Mandatory,Position=0)][String]$Path)

    Import-Module (Get-MDTModule)

    Get-SMBShare           | ? Path -eq $Path | Remove-SMBShare -Force -Verbose
    Get-MDTPersistentDrive | ? Path -eq $Path | % { Remove-MDTPersistentDrive -Name $_.Name -Verbose }
    Remove-Item -Path $Path -Verbose
}
