Function Get-NBTScan
{
    Class NBTHost_
    {
        Hidden [String]    $Line
        [String]           $Name
        [String]             $ID
        [String]           $Type
        [String]        $Service

        [String] X ([Int32]$Start,[Int32]$End)
        {
            Return @( $This.Line.Substring($Start,$End).TrimEnd(" ") )
        }

        NBTHost_([String]$Line)
        {
            $This.Line    = $Line
            $This.Name    = $This.X(0,19).TrimStart(" ")
            $This.ID      = $This.X(20,2)
            $This.Type    = $This.X(25,12)
        }
    }

    Class NBTStat_
    {
        Hidden [Object]   $Object
        [String]            $Name
        [String]       $IPAddress
        [Object[]]         $Hosts
        
        NBTStat_([Object[]]$Object)
        {
            $This.Object     = $Object
            $This.Name       = $Object[0].Split(":")[0]
            $This.IPAddress  = $Object[1].Split("[")[1].Split("]")[0]
            $This.Hosts      = $Object | ? { $_ -match "Registered" } | % { [NBTHost_]::New($_) }
        }
    }

    Class NBTStat
    {
        Hidden [Object]    $NBTStat = (nbtstat -N)
        Hidden [Object[]]  $Adapter = (Get-NetAdapter)
        Hidden [String[]]  $Service = (("00/{0}/Workstation {4};01/{0}/Messenger {6};01/{1}/Master Browser;03/{0}/Messenger {6};" + 
        "06/{0}/RAS Server {6};1F/{0}/NetDDE {6};20/{0}/File Server {6};21/{0}/RAS Client {6};22/{0}/{2} Interchange(MSMail C" + 
        "onnector);23/{0}/{2} Exchange Store;24/{0}/{2} Directory;30/{0}/{4} Server;31/{0}/{4} Client;43/{0}/{3} Control;44/{" + 
        "0}/SMS Administrators Remote Control Tool {6};45/{0}/{3} Chat;46/{0}/{3} Transfer;4C/{0}/DEC TCPIP SVC on Windows NT" +
        ";42/{0}/mccaffee anti-virus;52/{0}/DEC TCPIP SVC on Windows NT;87/{0}/{2} MTA;6A/{0}/{2} IMC;BE/{0}/{5} Agent;BF/{0}" + 
        "/{5} Application;03/{0}/Messenger {6};00/{1}/{7} Name;1B/{0}/{7} Master Browser;1C/{1}/{7} Controller;1D/{0}/Master " + 
        "Browser;1E/{1}/Browser {6} Elections;2B/{0}/Lotus Notes Server;2F/{1}/Lotus Notes ;33/{1}/Lotus Notes ;20/{1}/DCA Ir" + 
        "maLan Gateway Server;01/{1}/MS NetBIOS Browse Service") -f "UNIQUE","GROUP","Microsoft Exchange","SMS Clients Remote",
        "Modem Sharing","Network Monitor","Service","Domain").Split(";")
        Hidden [Hashtable] $Process 
        [Object[]]          $Output

        [String] SetService ([Object]$Hosts)
        {
            Return @( $This.Service | ? { $_ -match "$($Hosts.ID)/$($Hosts.Type)" } | % { $_.Split("/")[-1] } )
        }

        NBTStat()
        {
            ForEach ( $I in 0..( $This.Service.Count - 1 ) )
            { 
                $This.Service[$I]  = $This.Service[$I]
            }

            $This.Output           = @( )
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
                    $Item = [NBTStat_]::New($This.Process[0])

                    ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                    {
                        $Item.Hosts[$I].Service = $This.SetService($Item.Hosts[$I])
                    }

                    $This.Output += $Item
                }

                Default 
                { 
                    ForEach ( $X in 0..( $This.Process.Count - 1 ) )
                    {
                        $Item = [NBTStat_]::New($This.Process[$X])

                        ForEach ( $I in 0..( $Item.Hosts.Count - 1 ) )
                        {
                            $Item.Hosts[$I].Service = $This.SetService($Item.Hosts[$I])
                        }

                        $This.Output += $Item
                    }
                }
            }

            $This.Output = $This.Output | Sort-Object Name
        }
    }
    
    [NBTStat]::New().Output
}
