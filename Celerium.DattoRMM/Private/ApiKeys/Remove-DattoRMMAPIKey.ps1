function Remove-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Removes the Api & Api secret keys from the global variables

    .DESCRIPTION
        The Remove-DattoRMMAPIKey cmdlet removes the Api & Api secret keys
        from the global variables

    .EXAMPLE
        Remove-DattoRMMAPIKey

        Removes the Api & Api secret keys from the global variables

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$DattoRMMModuleApiKey) {
            $true   { Remove-Variable -Name "DattoRMMModuleApiKey" -Scope Global -Force }
            $false  { Write-Warning "The Datto API key is not set. Nothing to remove" }
        }

        switch ([bool]$DattoRMMModuleApiSecretKey) {
            $true   { Remove-Variable -Name "DattoRMMModuleApiSecretKey" -Scope Global -Force }
            $false  { Write-Warning "The Datto API secret key is not set. Nothing to remove" }
        }

    }

    end {}

}