Function Remove-FEShare
{
    [CmdLetBinding()]Param(
        
        [Parameter(Mandatory,Position=0)][String]$Name,
        [Parameter(Mandatory,Position=1)][String]$Path
    )

    Import-Module ( ( Get-ChildItem -Path ( Get-ItemProperty -Path "HKLM:\Software\Microsoft\Deployment 4" ).Install_Dir "*Toolkit.psd1" -Recurse ).FullName )

    Get-SMBShare           | ? Name -eq $Name -and Path -eq $Path | Remove-SMBShare -Force -EA 0
    Get-MDTPersistentDrive | ? Path -eq $Path | % { Remove-MDTPersistentDrive -Name $_.Name -VB -EA 0 }
    Remove-Item -Path $Path                                            -Recurse -Force -EA 0
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Secure Digits Plus LLC" -Recurse -Force -EA 0
}
