Function Update-Certificate
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory)][String]$ComputerName,
        [Parameter(Mandatory)][String]$KeyFile,
        [Parameter(Mandatory)][String]$Root,
        [Parameter()][PSCredential]$Credential = (Get-Credential)
    )
    
    Import-Module posh-ssh

    Class _CertFile
    {
        [String]$Name
        [String]$SourcePath
        [String]$TargetPath
        [Object]$x509
        [Object]$Content
        [Object]$Cert
        _CertFile([Int32]$ID,[String]$Path,[String]$Name)
        {
            $This.Name       = $Name
            $This.SourcePath = $Path
            $This.x509       = Invoke-SSHCommand -SessionID $ID -Command "openssl x509 -in $Path -text" | % Output
            $This.Content    = Invoke-SSHCommand -SessionID $ID -Command "cat $Path"                    | % Output
        }
        Transport([String]$Target)
        {
            If (!(Test-Path $Target))
            {
                Throw "Invalid path"
            }
            
            "$Target/$($This.Name)" | % {
                
                If (Test-Path $_ )
                {
                    Throw "Item exists"
                }
                
                $This.TargetPath = $_
                
                Set-Content -Path $_ -Value $This.Content
                $This.Cert = [System.Security.Cryptography.x509Certificates.x509Certificate2]::New($_)
            }
        }
    }

    $Session         = New-SSHSession -ComputerName $ComputerName -KeyFile $KeyFile -Credential $Credential
    $ID              = $Session.SessionID
    
    $File            = @( )
    $Trunk           = Invoke-SSHCommand -SessionID $ID -Command "ls $Root"        | % Output | Select-Object -Last 1
    $Branch          = Invoke-SSHCommand -SessionID $ID -Command "ls $Root/$Trunk" | % Output
    
    ForEach ($X in 0..($Branch.Count - 1) )
    {
        $Item = $Branch[$X]
        $Path = "$Root/$Trunk/$Item"
        $File += [_CertFile]::New($ID,$Path,$Item)
    }

    [Void](Remove-SSHSession -SessionID $ID)

    $File
}
