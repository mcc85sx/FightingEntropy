$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$Tree = Get-ChildItem $Path
If ( "CredSSP" -notin $Tree.PSChildName )
{
    New-Item -Path $Path -Name CredSSP -Verbose
}

$Path = "$Path\CredSSP"
$Tree = Get-ChildItem $Path
If ( "Parameters" -notin $Tree.PSChildName )
{
    New-Item -Path $Path -Name Parameters -Verbose
}

$Path = "$Path\Parameters"
If (!( Get-ItemProperty $Path | % AllowEncryptionOracle ))
{
    New-ItemProperty -Path $Path -Name AllowEncryptionOracle -Value 2 -Verbose
}
