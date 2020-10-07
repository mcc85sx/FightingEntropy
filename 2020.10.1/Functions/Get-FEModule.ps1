 Function Get-FEModule
{
    [CmdLetBinding( DefaultParameterSetName = 0,
                    HelpUri                 = 'http://www.github.com/secure-digits-plus-llc')]Param(                
        [Parameter( ParameterSetName        = 0 )][Switch]$All,
        [Parameter( ParameterSetName        = 1 )][Switch]$Registry,
        [Parameter( ParameterSetName        = 2 )][Switch]$Root,
        [Parameter( ParameterSetName        = 3 )][Switch]$Tree
    )

    Switch ($PSCmdlet.ParameterSetName) 
    { 
        0 { [_Module]::New() } 1 { [_Module]::New().Registry } 2 { [_Module]::New().Root } 3 { [_Module]::New().Tree } 
    }
}