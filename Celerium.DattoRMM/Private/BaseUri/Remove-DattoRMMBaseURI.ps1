function Remove-DattoRMMBaseURI {
<#
    .SYNOPSIS
        Removes the DattoRMM base URI global variable

    .DESCRIPTION
        The Remove-DattoRMMBaseURI cmdlet removes the DattoRMM base URI from
        the global variable

    .EXAMPLE
        Remove-DattoRMMBaseURI

        Removes the DattoRMM base URI value from the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMBaseURI.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$DattoRMMModuleBaseUri) {

            $true   {
                if ($PSCmdlet.ShouldProcess('DattoRMMModuleBaseUri')) {
                    Remove-Variable -Name "DattoRMMModuleBaseUri" -Scope Global -Force
                    Remove-Variable -Name "DattoRMMModuleBaseApiUri" -Scope Global -Force
                }
            }
            $false  { Write-Warning "The DattoRMM base URI variable is not set. Nothing to remove" }

        }

    }

    end {}

}