Function Get-CIFSShare ([String]$Server,[String]$Share,[String]$Mount="/mnt",[String]$Username)
{
    sudo mount.cifs //$Server/$Share $Mount $UserName
}
