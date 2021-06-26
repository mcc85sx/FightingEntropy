Function Get-WDSLinuxPackage
{
    Param(
        [String]$Base    = "https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux",
        [String]$Version = "6.03",
        [String]$Dest    = "$home\Downloads"
    )

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

    $Name           = "syslinux-$Version.zip"

    $File           = @{
        
        Source      = "$Base/$Name"
        Destination = "$Dest\$Name"
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
        "bios/com32/lib/libcom32.c32",
        "bios/com32/chain/chain.c32",
        "bios/com32/elflink/ldlinux/ldlinux.c32",
        "bios/com32/elflink/ldlinux/ldlinux.elf",
        "bios/com32/libutil/libutil.c32",
        "bios/com32/cmenu/libmenu/libmenu.c32",
        "bios/com32/gpllib/libgpl.c32",
        "bios/com32/lua/src/liblua.c32")
    {
        If ( $Item -in $Report.FullName )
        {
            $Report | ? Fullname -match $Item | % { $Return += $_ }
        } 
    }

    $Target = "$dest\syslinux"
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

    $Target
}
