Function _JoinRealm
{
    [CmdLetBinding()]Param([Parameter(Mandatory)][String]$Username)

    realm join -v -U $Username
}
