Class _NbtScan
{
    Hidden [Object]    $NBTStat = (nbtstat -N)
    Hidden [Object[]]  $Adapter = (Get-NetAdapter)
    Hidden [Object[]]  $Service = ([_NBTRef]::New().Output)
    Hidden [Hashtable] $Process 
    [Object[]]          $Output

    [String] GetService ([Object]$Hosts)
    {
        Return @( $This.Service | ? ID -match $Hosts.ID | ? Type -eq $Hosts.Type | % Service )
    }

    _NbtScan()
    {
        $This.Process          = @{ }
        $X                     = -1

        ForEach ( $I in 1..( $This.NBTStat.Count - 1 ) )
        {
            $Item              = $This.NBTStat[$I].Split(":")[0]
        
            If ( $Item -in $This.Adapter.Name )
            {
                $X ++
                $This.Process.Add($X,@( ))
            }

            If ( $Item.Length -gt 0 ) 
            { 
                $This.Process[$X] += $This.NBTStat[$I]
            }
        }

        Switch ($This.Process.Count)
        {
            1 
            {
                $Item = [_NBTStat]::New($This.Process[0])

                ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                {
                    $Item.Hosts[$I].Service = $This.GetService($Item.Hosts[$I])
                }

                $This.Output += $Item
            }

            Default 
            { 
                ForEach ( $X in 0..( $This.Process.Count - 1 ) )
                {
                    $Item = [_NBTStat]::New($This.Process[$X])

                    ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                    {
                        $Item.Hosts[$I].Service = $This.GetService($Item.Hosts[$I])
                    }

                    $This.Output += $Item
                }
            }
        }

        $This.Output = $This.Output | Sort-Object Name
    }
}
