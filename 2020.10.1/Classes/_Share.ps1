# _Company

Class _Share
{
    [String]           $Name = "FE001"
    [String]     $PSProvider
    [String]           $Root
    [String]    $Description = $Null
    [String]    $NetworkPath
    [Object]        $Company = [_Company]::New()

    Hidden [String[]] $Names
    Hidden [String[]] $Roots

    Hidden [Hashtable] $Hash = @{

        Name        = "Microsoft Deployment Toolkit" 
        Path        = ( Get-ChildItem ( Get-ItemProperty "HKLM:\Software\Microsoft\Deployment 4" ).Install_Dir -Filter *Toolkit.psd1 -Recurse ).FullName
        Description = ("The [Microsoft Deployment Toolkit]\\_It is *the* toolkit...\_...that Microsoft themselves uses...\" +
                        "_...to deploy additional toolkits.\\_It's not that weird.\_You're just thinking way too far into it" +
                        ", honestly.\\_Regardless... it is quite a fearsome toolkit to have in one's pocket.\_Or, wherever " +
                        "really...\_...at any given time.\\_When you need to be taken seriously...?\_Well, it *should* be t" +
                        "he first choice on one's agenda.\_But that's up to you.\\_The [Microsoft Deployment Toolkit].\_Eve" +
                        "n Mr. Gates thinks it's awesome." ).Replace("_","    ").Split('\')
    }

    _Share([String]$Name,[String]$Root,[String]$Description,[String]$NetworkPath)
    {
        If ( Test-Path $Root )
        {
            Throw "Path exists"
        }

        Else
        {
            $This.Root = $Root
        }

        If ( Get-SMBShare | ? Name -eq $Name -or Path -eq $Root )
        {
            Throw "Share exists"
        }

        If ( !$This.Hash.Path )
        {
            Throw ( "{0} is not installed" -f $_.Names )
        }

        Import-Module $This.Hash.Path -Verbose

        $This.Names        = ( Get-MDTPersistentDrive ).Name
        $This.Roots        = ( Get-MDTPersistentDrive ).Path

        If ( $Name -in $This.Names -or $Root -in $This.Roots )
        {
            Throw "MDT/FE Share exists"
        }

        If ( !! $This.Names )
        {
            $This.Name     = $This.Names        | % { @($_,$_[-1])[[Int32]($_.Count -gt 1)].Replace("DS","") } | % { "FE{0:d3}" -f ( [Int32]$_ + 1 ) }
        }

        $This.PSProvider   = "MDTProvider" 
        $This.Root         = $Root
        $This.Description  = $Description       | % { If ( !$_ ) { "-" } Else { $_ } }
        $This.NetworkPath  = $NetworkPath

        @{  Path           = $Root
            ItemType       = "Directory"      } | % { New-Item @_ -Verbose }

        @{  Name           = $Name
            Path           = $Root 
            FullAccess     = "Administrators" } | % { New-SMBShare @_ -Verbose }

        @{  Name           = $This.Name 
            PSProvider     = $This.PSProvider
            Root           = $This.Root
            Description    = $This.Description
            NetworkPath    = $This.NetworkPath
            Verbose        = $True            } | % { New-PSDrive @_ | Add-MDTPersistentDrive -Verbose }
    }
}