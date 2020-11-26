Function Get-ADLogin ([String]$Username)
{
    realm join -v -U $Username.ToUpper()
}
