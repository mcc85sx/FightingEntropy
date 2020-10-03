Function Get-FEModule
{
    [CmdLetBinding( DefaultParameterSetName = 0,
                    HelpUri                 = 'http://www.github.com/secure-digits-plus-llc')]Param(                
        [Parameter( ParameterSetName        = 0 )][Switch]$All,
        [Parameter( ParameterSetName        = 1 )][Switch]$Registry,
        [Parameter( ParameterSetName        = 2 )][Switch]$Root,
        [Parameter( ParameterSetName        = 3 )][Switch]$Tree
        # [Parameter( ParameterSetName        = 4 )][Switch]$Company
        # [Parameter( ParameterSetName        = 5 )][Switch]$Share
    )

    Switch ($PSCmdlet.ParameterSetName) 
    { 
        0 { [FEModule]::New() } 1 { [FEModule]::New().Registry } 2 { [FEModule]::New().Root } 3 { [FEModule]::New().Tree } 
    }
}
