# ADDS Cleanup Script
# -------------------
$Base       = "DC=securedigitsplus,DC=com"
$Code       = "(\w{2}\-){3}\d{5}"
$Gateway    = Get-ADComputer -Filter * | ? Name -match $Code
$Gateway    | Remove-ADComputer -Confirm:$False -Verbose
$OUList     = Get-ADObject -LDAPFilter "(objectClass=organizationalUnit)" -SearchBase $Base | ? Name -match "Gateway|((\w{2}\-){3}\d{5})" 
$OUList     | % { Set-ADObject -Identity $_.DistinguishedName -ProtectedFromAccidentalDeletion 0 -Verbose }
$OUList     | Remove-ADObject -Confirm:$False -Recursive -Verbose -EA 0
$Subnet     = Get-ADObject -LDAPfilter "(objectClass=subnet)" -SearchBase "CN=Configuration,$Base"
$Subnet     | ? Name -ne 172.16.0.0/19  | Remove-ADObject -Confirm:$False -Verbose
$SiteList   = Get-ADObject -LDAPFilter "(objectClass=site)" -SearchBase "CN=Configuration,$Base"
$SiteList   | ? Name -ne CP-NY-US-12065 | Remove-ADObject -Confirm:$False -Recursive -Verbose

# DHCP Cleanup Script
# -------------------
$Zone     = "securedigitsplus.com"
$ScopeID  = Get-DhcpServerv4Scope | % ScopeID
$DHCP     = @( Get-DhcpServerv4Lease -ScopeId $ScopeID | ? Hostname -match OPNsense )

If ($DHCP.Count -gt 0)
{
    $DHCP | Remove-DHCPServerV4Lease -Verbose -EA 0
}

# VM Guide Cleanup Script
# -----------------------
$Path     = GCI "$Env:ProgramData\Secure Digits Plus LLC" | ? Name -match "(Lab\(\d{8}\))" | % FullName
If (Test-Path $Path)
{
    Get-ChildItem $Path | ? Extension -match "log|txt" | Remove-Item -Verbose
}
