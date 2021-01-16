Class _DiskInfo
{
    Hidden [Object]   $Disk
    [String]         $Drive
    [String]         $Label
    Hidden [Object]  $Size_
    Hidden [Object]  $Free_
    Hidden [Object]  $Used_
    [Object]          $Size
    [Object]          $Free
    [Object]          $Used

    _DiskInfo([Object]$Disk)
    {
        $This.Disk    = $Disk
        $This.Drive   = $Disk.DeviceID
        $This.Label   = $Disk.VolumeName
        $This.Size_   = $Disk.Size/1GB
        $This.Free_   = $Disk.FreeSpace/1GB
        $This.Used_   = $This.Size_ - $This.Free_

        $This.Size    = "{0:n2} GB" -f $This.Size_
        $This.Free    = $This.Percent($This.Free_)
        $This.Used    = $This.Percent($This.Used_)
    }

    [String] Percent([Object]$Item)
    {
        Return @( "{0:n2} GB ({1:n2}%)" -f $Item, (($Item * 100)/$This.Size_))
    }
}
