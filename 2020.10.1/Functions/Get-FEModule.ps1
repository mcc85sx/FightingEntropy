Function Get-FEModule
{
    [CmdLetBinding( DefaultParameterSetName = "Default",
                    HelpUri                 = 'http://www.github.com/secure-digits-plus-llc')]Param(                
        [Parameter( ParameterSetName        = "Default"    )][Switch]         $All ,
        [Parameter( ParameterSetName        = "Registry"   )][Switch]    $Registry ,
        [Parameter( ParameterSetName        = "Properties" )][Switch]  $Properties ,
        [Parameter( ParameterSetName        = "Base"       )][Switch]        $Base , 
        [Parameter( ParameterSetName        = "Classes"    )][Switch]     $Classes , 
        [Parameter( ParameterSetName        = "Control"    )][Switch]     $Control , 
        [Parameter( ParameterSetName        = "Functions"  )][Switch]   $Functions , 
        [Parameter( ParameterSetName        = "Graphics"   )][Switch]    $Graphics ,
        [Parameter( ParameterSetName        = "Tools"      )][Switch]       $Tools ,
        [Parameter( ParameterSetName        = "Shares"     )][Switch]      $Shares )

    Switch ($PSCmdlet.ParameterSetName) 
    { 
        Default    { [_Module]::New()            }
        Registry   { [_Module]::New().Registry   }
        Properties { [_Module]::New().Properties }
        Base       { [_Module]::New().Base       } 
        Classes    { [_Module]::New().Classes    }
        Control    { [_Module]::New().Control    }
        Functions  { [_Module]::New().Functions  }
        Graphics   { [_Module]::New().Graphics   }
        Tools      { [_Module]::New().Tools      }
        Shares     { [_Module]::New().Shares     }
    }
}
