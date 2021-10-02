$Principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
If (!($Principal.IsInRole("Administrator") -or $Principal.IsInRole("Administrators")))
{
    Throw "Must run as administrator"
}

# OVA
$URL  = "https://app.box.com/s/u1uoseysbxk0hay31t12hm0m45wvl8tq"
$Dest = "$Home\downloads\remnux-v7-focal.ova"
$SHA  = "8be61dec9856f47bd2592b1c5b5e499cbcffc66a58114e6ca24c85e5a0fcc1d9"

# Download
Start-BitsTransfer -Source https://app.box.com/s/u1uoseysbxk0hay31t12hm0m45wvl8tq -Destination $Dest

# Check Hash
$Hash = Get-FileHash -Path $Dest -Algorithm SHA256
If ($Hash | ? Hash -match $SHA)
{
    Write-Theme "Hashes [+] Match"
}
Else
{
    Write-Theme "Hashes [!] Match" 12,4,15
}

# 7z
$7z     = "C:\ProgramData\chocolatey\tools\7z.exe"
If (!(Test-Path $7z))
{
    Set-ExecutionPolicy Bypass -Force
    Invoke-RestMethod chocolatey.org/install.ps1 | Invoke-Expression
}

$Output = "C:\VDI\remnux"
If (!(Test-Path $Output))
{
    New-Item $Output -ItemType Directory
}
& $7z x $Dest -o"$Output"
$gz     = Get-ChildItem $Output | ? Extension -eq .gz | % FullName

& $7z x $gz -o"$Output"
$vmdk   = Get-ChildItem $Output | ? Extension -eq .vmdk | % FullName
$vhd    = $Vmdk -Replace "vmdk","vhd"

$Qemu = "C:\Program Files\qemu\qemu-img.exe"
If (!(Test-Path $Qemu))
{
    choco install qemu -y
}

# Qemu does NOT convert from [vmdk] to [vhd] correctly
# & $Qemu convert -f vmdk $vmdk -O vhdx $Vhd
