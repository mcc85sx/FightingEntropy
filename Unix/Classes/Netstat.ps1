
Class Netstat
{
    [String[]]   $Section = ("Internet {0};UNIX domain sockets;Bluetooth {0}" -f "connections" -Split ";")
    [Object] $InputObject
    [Object]        $Swap
    [Object]      $Output

    Netstat()
    {
        Class InternetConnections
        {
            Hidden [String] $Line
            [String] $Proto
            [UInt32] $RecvQ
            [UInt32] $SendQ
            [String] $Local
            [String] $Foreign
            [String] $State

            [String] X ([Int32]$Start,[Int32]$Length)
            {
                Return ( $This.Line.Substring($Start,$Length).TrimEnd(" ") )
            }

            InternetConnections([String]$In)
            {
                $This.Line    = $In
                $This.Proto   = $This.X(0,6)
                $This.RecvQ   = $This.X(6,6)
                $This.SendQ   = $This.X(13,7)
                $This.Local   = $This.X(20,24)
                $This.Foreign = $This.X(44,24)
                $This.State   = $In.Substring(68)
            }
        }

        Class UnixDomainSockets
        {
            Hidden [String] $Line 
            [String] $Proto
            [UInt32] $RefCnt
            [String] $Flags
            [String] $Type
            [String] $State
            [UInt32] $INode
            [String] $Path

            [String] X ([Int32]$Start,[Int32]$Length)
            {
                Return ( $This.Line.Substring($Start,$Length).TrimEnd(" ") )
            }

            UnixDomainSockets([String]$In)
            {
                # $In = "Proto RefCnt Flags       Type       State         I-Node   Path"
                $This.Line     = $In
                $This.Proto    = $This.X(0,6)
                $This.RefCnt   = $This.X(6,7)
                $This.Flags    = $This.X(13,12)
                $This.Type     = $This.X(25,11)
                $This.State    = $This.X(36,14)
                $This.INode    = $This.X(50,9)
                $This.Path     = $In.Substring(60)
            }
        }

        Class BluetoothConnections
        {
            Hidden [String] $Line
            [String] $Proto
            [String] $Destination
            [String] $Source
            [String] $State
            [String] $PSM
            [String] $DCID
            [String] $SCID
            [String] $IMTU
            [String] $Security

            [String] X ([Int32]$Start,[Int32]$Length)
            {
                Return ( $This.Line.Substring($Start,$Length).TrimEnd(" ") )
            }

            BluetoothConnections([String]$In)
            {
                # $In = "Proto  Destination       Source            State         PSM DCID   SCID      IMTU    OMTU Security"
                $This.Line             = $In
                $This.Proto            = $This.X(0,7)
                $This.Destination      = $This.X(7,18)
                $This.Source           = $This.X(25,18)
                $This.State            = $This.X(43,14)
                $This.PSM              = $This.X(57,4)
                $This.DCID             = $This.X(61,7)
                $This.SCID             = $This.X(68,10)
                $This.IMTU             = $This.X(78,8)
                $This.OMTU             = $This.X(86,5)
                $This.Security         = $In.Substring(91)
            }
        }

        $This.InputObject = (netstat)
        $Mode             = -1
        $This.Output      = @( )

        ForEach ( $I in 0..( $This.InputObject.Count - 1 ) )
        {
            $Line = $This.InputObject[$I]

            If ( $Line -match $This.Section[0] ) { $Mode = 0 }
            If ( $Line -match $This.Section[1] ) { $Mode = 1 }
            If ( $Line -match $This.Section[2] ) { $Mode = 2 }
 
            If ( $Line.Substring(0,5) -notmatch "Proto" )
            {
                Switch ($Mode)
                {
                    0 { $This.Output += [InternetConnections]::New($Line)  }
                    1 { $This.Output += [UnixDomainSockets]::New($Line)   }
                    2 { $This.Output += [BluetoothConnections]::New($Line) }
                }
            }
        }
    }
}
