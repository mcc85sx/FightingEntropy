# Function not working on PS6+, was toying with parsing the input for PS7

Function Get-Certificate
{
    [CmdLetBinding()]Param(
        [String]$Organization = "",
        [String]$CommonName   = "localhost"
    )

    If ( ! ( Test-Connection 1.1.1.1 -Count 1 ) ) 
    { 
        Throw "Unable to verify internet connection" 
    }

    [Net.ServicePointManager]::SecurityProtocol = 3072
    
    # These (2) lines are from Chrissie Lamaire's script
    # (she's a badass at this.)
    # https://gallery.technet.microsoft.com/scriptcenter/Get-ExternalPublic-IP-c1b601bb

    $ExternalIP       = Invoke-RestMethod "http://ifconfig.me/ip"
    $Ping             = Invoke-RestMethod "http://ipinfo.io/$ExternalIP"

    If ( $Host.Major.Version -gt 5 )
    {
        Throw "PS6/7 not working"
    }

    [_Certificate]::New($ExternalIP,$Ping,$Organization,$CommonName)
}

Class _StrSearch
{
    Hidden [String]   $Body 
    [String[]] $Line
    [UInt32]   $Height
    [Object[]] $Result
    [Object]   $Output

    _StrSearch([String]$Body)
    {
        $This.Body     = $Body
        $This.Line     = $Body -Split "`n"
        $This.Height   = $This.Line.Count
        $This.Result   = @( )
    }

    _Add([String]$ID,[String]$Search)
    {
        If ( $ID -notin $This.Result.Label )
        {
            If ( $This.Body -match $Search )
            {
                $Item = [_StrReturn]::New($ID,$Search)

                ForEach ( $I in 0..( $This.Line.Count - 1 ) )
                {
                    If ( $This.Line[$I] -match $Search )
                    {
                        $Item._Index($I,$This.Line[$I])
                    }
                }

                $This.Result += $Item
            }
        }
    }

    [String[]] _Condense([Object]$Object)
    {
        Return @( Switch ($Object.Count)
        {
            1
            {
                $Object.Result
            }

            Default
            {
                ForEach ( $I in 0..( $Object.Result.Count - 1 ) ) 
                { 
                    $Object.Result[$I] 
                }
            }
        })
    }

    _Return([Object[]]$Result)
    {
        If ( $Result.Count -eq 0 )
        {
            Write-Host "No Results"
        }

        Switch ( $Result.Count )
        {
            1
            {
                $This._Condense($Result)
            }

            Default
            {
                ForEach ( $I in 0..( $Result.Count - 1 ) ) 
                {
                    $This._Condense($Result[$I])
                }
            }
        }
    }
}

Class _StrReturn
{
    [String]   $Label
    [String]   $Input
    [Object[]] $Result

    _StrReturn([String]$ID,[String]$Label)
    {
        $This.Label  = $ID
        $This.Input  = $Label

        $This.Result = @( )
    }

    _Index([UInt32]$Index,[String]$String)
    {
        $This.Result += [_StrResult]::New($Index,$String)
    }
}

Class _StrResult
{
    [UInt32] $Index
    [String] $String

    _StrResult([UInt32]$Index,[String]$String)
    {
        $This.Index  = $Index
        $This.String = ($String) -Replace "(\s+)"," "
    }
}

$Test = [_StrSearch]::New($XP)
$Test._Add("IP","74.XX.XXX.XX")
$Test._Add("Hostname","xxxxxxxxxxx")
$Test._Add("City","xxxxxxxxxxx")
$Test._Add("Region","xxxxxxxxx")
$Test._Add("Country","xxx")
$Test._Add("Location","xxxxxxxxx")
$Test._Add("Organization","xxxxxxxxx")
$Test._Add("Postal","xxxxxxx")
$Test._Add("Timezone","America/New_York")
$Test._Add("Readme","https://ipinfo.io/missingauth")

ForEach ( $Result in $Test.Result )
{
    (@("-")*108 -join '')
    "$( $Result.Label ) : $( $Result.Input )"
    " "
    ForEach ( $X in $Result.Result )
    {
        "{0:d3} {1}" -f $X.Index, $X.String
    }
    " "
}
