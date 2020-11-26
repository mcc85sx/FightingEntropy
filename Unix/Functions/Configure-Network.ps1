Function Configure-Network
{
    $Network = [Network]::New()

    $Network.Host
    $Network.Interface
    $Network.Network

    #If ( $Network.Host.Hostname -ne $Target )
    #{
    #    hostnamectl set-hostname $Target
    #}
            
    $IPAddress = $Network.Interface | ? Flags -match 4163 | % IPV4Address
    $Content   = Get-Content -Path "/etc/hosts"
    
    Switch ($IPAddress.Count)
    {
        0
        { 
            Throw "Invalid entry" 
        }

        1
        {
            $Content += ( "{0} {1} {2}" -f $IPAddress,$Network.Host.HostID, $Network.Host.HostName )
        }

        Default 
        { 
            ForEach ( $IP in $IPAddress )
            {
                $Item = ( "{0} {1} {2}" -f $IP, $Network.Host.HostID, $Network.Host.HostName )
                If ( $Item -notin $Content )
                {
                    $Content += $Item
                }
            }
        }
    }

    Set-Content -Path "/etc/hosts" -Value @($Content)
}
