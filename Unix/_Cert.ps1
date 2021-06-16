
Class _CertFile
    {
        [String]$Name
        [String]$Path
        [Object]$x509
        [Object]$Content
        _CertFile([Int32]$ID,[String]$Path,[String]$Trunk,[String]$Branch)
        {
            $This.Name    = $Branch
            $This.Path    = "$Path/$Trunk/$Branch"
            $This.x509    = Invoke-SSHCommand -SessionID $ID -Command "openssl x509 -in $($This.Path) -text" | % Output
            $This.Content = Invoke-SSHCommand -SessionID $ID -Command "cat $($This.Path)" | % Output
        }
    }

Function _Certificate
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory)][String]$ComputerName,
        [Parameter(Mandatory)][String]$KeyFile,
        [Parameter(Mandatory)][String]$Path
    )

    Import-Module posh-ssh

    New-SSHSession -ComputerName $ComputerName -KeyFile $KeyFile -Credential certsrv 
    $ID              = Get-SSHSession | % SessionID
    
    $File            = @( )
    $Trunk           = Invoke-SSHCommand -SessionID $ID -Command "ls $Path"        | % Output | Select-Object -Last 1
    $Branch          = Invoke-SSHCommand -SessionID $ID -Command "ls $Path/$Trunk" | % Output
    
    ForEach ($X in 0..($Branch.Count - 1) )
    {
        $File += [_CertFile]::New($ID,$Path,$Trunk,$Branch[$X])
    }

    Remove-SSHSession -SessionID $ID | Out-Null

    $File
}
