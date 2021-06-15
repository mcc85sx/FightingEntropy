Function _Certificate
{
    Class _Section
    {
        [Object] $Name
        [Object] $Content

        _Section([Object]$Section)
        {
            $This.Name    = [Regex]::Matches($Section[0],"(\w+\.\w+)").Value
            $This.Content = $Section[1..($Section.Count - 2)]
        }
    }

    Class _Body
    {
        [Object] $Body
        [Object] $Section

        _Body([Object]$Body)
        {
            $This.Body         = $Body
            $X                 = -1
            $This.Section      = @{ }
            $Swap              = @( )
            
            ForEach ( $Line in $This.Body )
            {
                Switch -Regex ($Line)
                {
                    "(\[\{-{20}\/\w+\.\w+\}\])"
                    {
                        $Swap  = @( )
                        $Swap += $Line
                    }

                    "(\[\{-{20}\\\w+\.\w+\}\])"
                    {
                        $X    ++
                        $Swap += $Line
                        $This.Section.Add($X,$Swap)
                    }

                    "^exit$"
                    {

                    }

                    Default
                    {
                        $Swap += $Line
                    }
                }
            }
        }
    }

    Class _Stack
    {
        [Object]     $Stack
        [Object]      $Head
        [Object]      $Body
        [Object]      $Foot

        _Stack([Object]$Content)
        {            
            $This.Stack   = $Content
            $S            = $Content.Count - 1
            $H            =  0..$S     | ? { $This.Stack[$_] -match "^it$" }
            $F            = (0..$S     | ? { $This.Stack[$_] -match "(\[\{-{20}\\\w+\.\w+\}\])"})[-1]
            
            If ( $This.Stack )
            {
                $This.Head    = 0..($H+1)  | % { $This.Stack[$_] }
                $This.Body    = ($H+1)..$F | % { $This.Stack[$_] }
                $This.Foot    = ($F+1)..$S | % { $This.Stack[$_] }
            }
        }
    }

    Class _Object
    {
        [Object]               $Path
        Hidden [Object[]]   $Content
        [Object]              $Stack
        [Object]               $Body
        [Object[]]            $Chain

        _Object([String]$Path)
        {
            If (!(Test-Path $Path))
            {
                Throw "Invalid path"
            }

            $This.Path    = $Path
            $This.Content = Get-Content $Path
            $This.Stack   = [_Stack] $This.Content
            $This.Body    = [_Body]$This.Stack.Body
            $This.GetChain()
        }

        GetChain()
        {
            $This.Chain   = @( )
            $C            = $This.Body.Section.Count - 1

            0..$C         | % {

                $This.Chain += [_Section]::New($This.Body.Section[$_])
            }
        }
    }
    
    $Username = "root"
    $Hostname = "cp"
    $LogPath  = "/home"
    $LogName  = "logfile.txt"
    $CertPath = "/etc/ssl/certs"

    ssh $username@$hostname | tee $LogPath/$LogName

# Log/Certificate Dump
8
set x=/var/etc/acme-client/certs
set y=`ls $x | tail -n 1`
set z=$x/$y
ls $z > swap
set list=`cat swap`
foreach i ($list)
echo "[{--------------------/$i}]"
openssl x509 -in $z/$i -text
echo "[{--------------------\$i}]"
echo ""
end
exit
exit

    $Path    = "/home/$LogName"
    $Content = Get-Content $LogPath/$LogName

    If ( Test-Path $Path )
    {
        Remove-Item $Path -Force -Verbose
    }

    Set-Content $Path $Content -Encoding UTF8 -Force -Verbose
    Copy-Item $Path /mnt/$LogName -Force -Verbose

    $Path     = "/mnt/$LogName"
    $Chain    = [_Object] $Path | % Chain

    ForEach ( $Item in $Chain )
    {
        Set-Content -Path "$CertPath/$($Item.Name)" -Value $Item.Content -Force -Verbose
    }
}
