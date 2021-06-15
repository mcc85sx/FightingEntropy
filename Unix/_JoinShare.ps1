Function _JoinShare
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,Position=0)][String]$Username,
        [Parameter(Mandatory,Position=1)][String]$Server,
        [Parameter(Mandatory,Position=2)][String]$Share
    )

    sudo mount.cifs "//$Server/$Share" /mnt -o user=$Username
}
