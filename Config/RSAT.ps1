Class RSAT
{
    [String]$Path
    [String]$Hash
    RSAT([String]$Path)
    {
        $This.Path = $Path
        $This.Hash = Get-FileHash -Path $Path -Algorithm SHA256
    }
}

$List = @("{0}WS2016-x64.msu {0}WS2016-x86.msu {0}WS_1709-x64.msu {0}WS_1709-x86.msu {0}WS_1803-x64.msu {0}WS_1803-x86.msu" -f "WindowsTH-RSAT_" -Split " ")
$URL  = "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB"
New-Item $Home\Desktop\RSAT -ItemType Directory
$List | % { Start-BitsTransfer -Source "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/$_" -Destination "$Home\Desktop\RSAT\$_" }

$Base = "x64","x86" | % { "WS2016-$_","WS_1709-$_","WS_1803-$_" } | % { "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/WindowsTH-RSAT_$_.msu" } 
