  # https://devblogs.microsoft.com/scripting/use-powershell-to-manipulate-information-with-cim/
  
  # Revisiting w/ Classes
    
    Class TimeObject
    {
        [String] $ClassName
        [String] $PropertyName
        [Bool]   $Writable

        TimeObject([String]$ClassName,[String]$PropertyName,[Bool]$Writable)
        {
            $This.ClassName    = $ClassName
            $This.PropertyName = $PropertyName
            $This.Writable     = $Writable
        }
    }

    Class TimeAttack
    {
        Hidden [Object[]]              $List
        [Object[]]                   $Output

        TimeAttack()
        {
            $This.Output = @( )
            $This.List   = Get-CimClass

            ForEach ( $Class in $This.List )
            {
                ForEach ( $Property in $Class.CimClassProperties )
                {
                    If ( $Property.Qualifiers.Name -contains "Write" )
                    {
                        $This.Output += [TimeObject]::New($Class.CimClassName,$Property.Name,1)
                    }
                }
            }
        }
    }

    $Time   = [System.Diagnostics.Stopwatch]::StartNew()
    [TimeAttack]::New().Output
    $Time.Stop()

    Write-Host $Time.Elapsed
   
    # https://devblogs.microsoft.com/scripting/use-powershell-to-manipulate-information-with-cim/
    
    $Time                        = [System.Diagnostics.Stopwatch]::StartNew()
    $ClassList                   = Get-CimClass
    $Return                      = Foreach ( $CimClass in $ClassList )
    {
        Foreach ( $CimProperty in $CimClass.CimClassProperties )
        {
            If ( $CimProperty.Qualifiers.Name -contains 'write' )
            {
                [PSCustomObject]@{

                    ClassName    = $CimClass.CimClassName
                    PropertyName = $CimProperty.Name
                    Writable     = $true

                }
            }
        }
    }

    $Time.Stop()
    $Time

    Write-Output "Complete [+] Time: $( $Time.Elapsed )"

    # What I originally rewrote, reducing variables and time (tried to go completely without the $X) 
    # ...couldn't do it. So there's an $X. Big whoop.

    $Time = [ System.Diagnostics.Stopwatch ]::StartNew()

    $Report                   = Get-CimClass | ? { $_.CimClassProperties.Qualifiers.Name -contains 'write' } | % { 

        $X                    = $_.CimClassName

        $_.CimClassProperties | ? { $_.Qualifiers.Name -contains 'write' } | % {

            [ PSCustomObject ]@{ 

                ClassName     = $X
                PropertyName  = $_
                Writeable     = $True
            } 
        }
    }

    $Time.Stop()

    Write-Output "Complete [+] Time: $( $Time.Elapsed )"
