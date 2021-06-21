Function Install-WDSLinuxPackage # # tutorial by https://kenvb.gitbook.io/deploy-linux-with-microsoft-wds/
{
    [CmdLetBinding()]Param([Parameter()][String]$Root)

    If((gcim Win32_OperatingSystem).Caption -notmatch "Server")
    {
        Throw "Not a valid server"
    }

    If ( Get-WindowsFeature | ? Name -match WDS | ? Installed -eq 0 )
    {
        Throw "WDS is not installed"
    }

    Class Arch
    {
        [String]$Name
        [String]$Path
        [Object]$Files
        [Object]$Graphic
        [String[]]$Config
        Arch([String]$Root,[String]$Files,[String]$Arch,[String]$Graphic)
        {
            $This.Name    = $Arch
            $This.Path    = "$Root\Boot\$Arch"
            $This.Graphic = Get-Item $Graphic
            
            # Test file path
            If (!(Test-Path $Files))
            {
                Throw "Import path invalid"
            }

            # Copy all syslinux files
            ForEach ($File in Get-ChildItem $Files)
            {
                If (!(Test-Path "$($This.Path)/$($File.Name)"))
                {
                    Copy-Item -Path $File.FullName -Destination $This.Path -Verbose
                }
            }

            # Copy/Newname these files
            ForEach ( $I in ("pxelinux.0","pxelinux.com"),("abortpxe.com","abortpxe.0"),("pxeboot.n12","pxeboot.0"))
            {
                Switch(Test-Path $I[1])
                {
                    1 {} 0 { Copy-Item -Path "$($This.Path)\$($I[0])" -Destination "$($This.Path)/$($I[1])" -Verbose }
                }
            }

            # Test/Create directories
            ForEach ( $I in "linux","pxelinux.cfg" )
            {
                Switch(Test-Path $I)
                {
                    1 {} 0 { New-Item -Path $This.Path -Name $I -ItemType Directory -Verbose }
                }
            }

            # Copy system graphic
            Copy-Item -Path $This.Graphic.FullName -Destination "$($This.Path)/pxelinux.cfg" -Verbose
            
            # Set configuration
            $This.Config = @("DEFAULT vesamenu.c32",
            " PROMPT 0",
            " NOESCAPE 0",
            " ALLOWOPTIONS 0",
            " # Timeout in units of 1/10 s",
            " TIMEOUT 300",
            " MENU MARGIN 10",
            " MENU ROWS 16",
            " MENU TABMSGROW 21",
            " MENU TIMEOUTROW 26",
            " MENU COLOR BORDER 30;44        #20ffffff #00000000 none",
            " MENU COLOR SCROLLBAR 30;44        #20ffffff #00000000 none",
            " MENU COLOR TITLE 0         #ffffffff #00000000 none",
            " MENU COLOR SEL   30;47        #40000000 #20ffffff",
            " MENU BACKGROUND $($This.Graphic.Name)",
            " MENU TITLE PXE Boot Menu",
            "  #---",
            "  LABEL wds",
            "  MENU LABEL Windows Deployment Services",
            "  KERNEL pxeboot.0",
            "   #---",
            "  LABEL Abort",
            "  MENU LABEL AbortPXE",
            "  Kernel abortpxe.0",
            "   #---",
            "  LABEL local ",
            "  MENU DEFAULT",
            "  MENU LABEL Boot from Harddisk",
            "  LOCALBOOT 0",
            "  Type 0x80" -join "`n")
            
            # Write configuration
            Set-Content -Path "$($This.Path)\pxelinux.cfg\default" -Value $This.Config -Verbose

            # Collect file tree
            $This.Files  = Get-ChildItem $This.Path
        }
    }

    Class WDS
    {
        [String]$Path
        [Object]$Item
        [Object]$Arch
        [String]$Graphic
        WDS([String]$Root,[String]$Files)
        {
            If (!(Test-Path $Root))
            {
                Throw "Invalid path"
            }

            $This.Path    = $Root
            $This.Item    = Get-ChildItem $Root
            $This.Graphic = "$Root\Interop\Graphics\low_res_bg.jpg"
            $This.Arch    = @( )

            ForEach ( $Item in 86,64 )
            {
                $This.Arch += [Arch]::New($Root,$Files,"x$Item",$This.Graphic)
            }
        }
    }

    If ( $Root -eq $Null )
    {
        $Root = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\services\WDSServer\Providers\WDSTFTP" | % RootFolder
    }

    $Syslinux = Get-WDSLinuxPackage

    [WDS]::New($Root,$Syslinux)
}
