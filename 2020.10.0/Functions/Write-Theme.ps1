Function Write-Theme # Cross Platform
{
    [CmdLetBinding()]Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][ValidateNotNullOrEmpty()][Object]$InputObject,
        [Parameter()][Int32[]]$Palette=@(10,12,15,0))

    $Theme = [FEObject]::New($InputObject)
    $Theme.Draw($Palette)
}