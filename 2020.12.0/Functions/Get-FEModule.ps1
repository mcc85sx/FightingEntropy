Function Get-FEModule
{
    [CmdLetBinding( DefaultParameterSetName = "Default",
                    HelpUri                 = "http://www.github.com/mcc85sx/FightingEntropy" )]
    Param(                
        [Parameter( ParameterSetName        = "Default"     )][Switch]          $All ,
        [Parameter( ParameterSetName        = "Classes"     )][Switch]      $Classes , 
        [Parameter( ParameterSetName        = "Control"     )][Switch]      $Control , 
        [Parameter( ParameterSetName        = "Functions"   )][Switch]    $Functions , 
        [Parameter( ParameterSetName        = "Graphics"    )][Switch]     $Graphics , 
        [Parameter( ParameterSetName        = "Tools"       )][Switch]        $Tools )

    Switch ($PSCmdlet.ParameterSetName) 
    {  
        Default      { [_Module]::New()              }
        Classes      { [_Module]::New().Classes      }
        Control      { [_Module]::New().Control      }
        Functions    { [_Module]::New().Functions    }
        Graphics     { [_Module]::New().Graphics     }
    }
}
