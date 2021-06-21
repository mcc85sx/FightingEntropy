# https://wiki.syslinux.org/wiki/index.php?title=WDSLINUX
# https://kenvb.gitbook.io/deploy-linux-with-microsoft-wds/
# Booting Linux via WDS

Class ZipItem
{
    [UInt32]$Index
    [String]$Name
    [String]$Fullname
    ZipItem([UInt32]$Index,[String]$Name,[String]$Fullname)
    {
        $This.Index    = $Index
        $This.Name     = $Name
        $This.Fullname = $FullName 
    }
}

Class Arch
{
    [String]$Name
    [String]$Path
    [Object]$Files
    [String]$Image
    Arch([String]$Root,[String]$Arch)
    {
        $This.Name  = $Arch
        $This.Path  = "$Root\Boot\$Arch"
        
        $This.Prime()
        
        $This.Files = Get-ChildItem $This.Path
    }
    Prime()
    {
        ForEach ( $I in ("pxelinux.0","pxelinux.com"),("abortpxe.com","abortpxe.0"),("pxeboot.n12","pxeboot.0"))
        {
            Copy-Item -Path "$($This.Path)\$($I[0])" -Destination "$($This.Path)/$($I[1])" -Verbose
        }

        "linux","pxelinux.cfg"| % {
    
            New-Item -Path $This.Path -Name $_ -ItemType Directory -Verbose
        }
    }
    [String[]] GetConfig()
    {
        Return @("DEFAULT vesamenu.c32",
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
        " MENU BACKGROUND {0}",
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
        "  Type 0x80")
    }
}

Class WDS
{
    [String]$Path
    [Object]$Item
    [Object]$Arch
    WDS([String]$Root)
    {
        If (!(Test-Path $Root))
        {
            Throw "Invalid path"
        }

        $This.Path = $Root
        $This.Item = Get-ChildItem $Root
        $This.Arch = @( )

        ForEach ( $Item in 86,64 )
        {
            $This.Arch += [Arch]::New($Root,"x$Item")
        }
    }
}

$Base           = "https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux"
$Version        = 6.03
$Name           = "syslinux-$Version.zip"

$File           = @{
    
    Source      = "$Base/$Name"
    Destination = "$Home\Downloads\$Name"
}

Import-Module BitsTransfer
Start-BitsTransfer @File
Add-Type -AssemblyName System.IO.Compression.FileSystem

$Zip            = [System.IO.Compression.ZipFile]::OpenRead($File.Destination)
$Hash           = @{ }

ForEach ( $Item in $Zip.Entries )
{
    $Hash.Add($Hash.Count,[ZipItem]::New($Hash.Count,$Item.Name,$Item.FullName))
}

$Report         = @( )
ForEach ( $X in 0..($Hash.Count - 1))
{
    $Report    += $Hash[$X]
}

$Return         = @( )
ForEach ( $Item in 
    "bios/core/pxelinux.0",
    "bios/com32/menu/vesamenu.c32",
    "bios/com32/chain/chain.c32",
    "bios/com32/elflink/ldlinux/ldlinux.c32",
    "bios/com32/elflink/ldlinux/ldlinux.elf",
    "bios/com32/libutil/libutil.c32",
    "bios/com32/cmenu/libmenu/Libmenu.c32",
    "bios/com32/gpllib/libgpl.c32",
    "bios/com32/lua/src/liblua.c32")
{
    If ( $Item -in $Report.FullName )
    {
        $Report | ? Fullname -match $Item | % { $Return += $_ }
    } 
}

$Target = "$Home\Desktop\syslinux"
If (!(Test-Path $Target))
{
    New-Item -Path $Target -ItemType Directory -Verbose
}

ForEach ( $Item in $Return )
{
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($Zip.Entries[$Item.Index],"$Target\$($Item.Name)",$True)
}

$Zip.Dispose()
Remove-Item -Path $File.Destination -Verbose
