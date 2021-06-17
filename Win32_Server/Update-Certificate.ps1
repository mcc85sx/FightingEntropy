Function Update-Certificate
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory)][String]$ComputerName,
        [Parameter(Mandatory)][String]$KeyFile,
        [Parameter(Mandatory)][String]$Root,
        [Parameter()][PSCredential]$Credential = (Get-Credential)
    )
    
    Import-Module posh-ssh

    Class _CertStoreObject
    {
        [String] $Path
        [String] $Thumbprint
        [String] $Subject
        [String] $Issuer
        [String] $FriendlyName
        [String] $NotBefore
        [String] $NotAfter
        [Object] $Extensions
        _CertStoreObject([String]$Path,[Object]$CSO)
        {
            $This.Path         = $Path
            $This.Subject      = $CSO.Subject
            $This.Issuer       = $CSO.Issuer
            $This.Thumbprint   = $CSO.Thumbprint
            $This.FriendlyName = $CSO.FriendlyName
            $This.NotBefore    = $CSO.NotBefore.ToString()
            $This.NotAfter     = $CSO.NotAfter.ToString()
            $This.Extensions   = $CSO.Extensions
        }
    }

    Class _CertStore
    {
        [Object] $Files
        [Object] $Store
        Hidden [Object] $Report
        _CertStore([Object[]]$Files)
        {
            $This.Files = $Files
            $This.Store = @( )
            $Path = "Cert:\"

            ForEach ( $Item in Get-Childitem $Path -Recurse )
            {
                Switch -Regex ($Item.GetType().Name)
                {
                    X509Store
                    {
                        $Path = "Cert:\$($Item.Location)\$($Item.Name)"
                    }
        
                    X509Certificate
                    {
                        $This.Store += [_CertStoreObject]::New($Path,$Item) 
                    }
                }
            }
        }

        Import([String]$Target)
        {
            ForEach ( $File in $This.Files )
            {
                $Subject        = $Null
                $Thumbprint     = $Null

                If ($File.Subject -in $This.Store.Subject)
                {
                    $Subject    = $This.Store | ? Subject -match $File.Subject
                    Write-Host "[$Subject]"
                }

                If ($File.Thumbprint -in $This.Store.Thumbprint)
                {
                    $Thumbprint = $This.Store | ? Thumbprint -match $File.Thumbprint
                    Write-Host "[$Thumbprint]"
                }
                
                If ( $Subject -or $Thumbprint )
                {    
                    Switch((Host).UI.PromptForChoice("Certificate conflict [!]","Duplicate subject/thumbprint signature found, replace or cancel?",
                    @("&Replace","&Skip"),1))
                    {
                        0 
                        { 
                            "Replacing [{0}] {1}" -f $File.Thumbprint, $File.Subject
                        }

                        1 
                        { 
                            "Skipping [{0}] {1}" -f $File.Thumbprint, $File.Subject
                        }
                    }
                }

                Else
                {
                    $File.Import($Target)
                }
            }
        }

        _Report()
        {
            $This.Report        = ForEach ($Item in $This.Files)
            {
                ((        "Name" , $Item.Name),
                 (  "SourcePath" , $Item.SourcePath),
                 (  "TargetPath" , $Item.TargetPath),
                 (     "Subject" , $Item.Certificate.Subject),
                 (      "Issuer" , $Item.Certificate.Issuer),
                 ("SerialNumber" , $Item.Certificate.SerialNumber),
                 (   "NotBefore" , $Item.Certificate.NotBefore.ToString()),
                 (    "NotAfter" , $Item.Certificate.NotAfter.ToString()),
                 (  "Thumbprint" , $Item.Certificate.Thumbprint)) | % { "{0}{1}: {2}" -f (@(" ")*(20-$_[0].Length) -join ''), $_[0], $_[1] } 
                " "
                $Item.x509;
                "-------------------------------------";
                $Item.Certificate.ToString().Split("`n")
            }
        }
    }
    
    Class _CertFile
    {
        [String]$Name
        [String]$SourcePath
        [Object]$x509
        [Object]$Content
        [String]$TargetPath
        [Object]$Certificate
        _CertFile([Int32]$ID,[String]$Path,[String]$Name)
        {
            $This.Name       = $Name
            $This.SourcePath = $Path
            $This.x509       = Invoke-SSHCommand -SessionID $ID -Command "openssl x509 -in $Path -text" | % Output
            $This.Content    = Invoke-SSHCommand -SessionID $ID -Command "cat $Path"                    | % Output
        }
        Import([String]$Target)
        {
            If (!(Test-Path $Target))
            {
                Throw "Invalid path"
            }
            
            $This.TargetPath = "$Target\$($This.Name)"
            
            If (Test-Path $This.TargetPath)
            {
                Throw "Item exists"
            }
                
            Else
            {
                Set-Content -Path $This.TargetPath -Value $This.Content -Verbose
                $This.Certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]($This.TargetPath)
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

    $Store           = [_CertStore]::New($File)

    $Store
}
