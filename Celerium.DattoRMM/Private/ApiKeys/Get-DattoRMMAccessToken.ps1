function Get-DattoRMMAccessToken {
<#
    .SYNOPSIS
        Gets the stored JWT access token

    .DESCRIPTION
        The Get-DattoRMMAccessToken cmdlet gets the stored JWT access token

    .EXAMPLE
        Get-DattoRMMAccessToken

        Gets the stored JWT access token

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMAccessToken.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {}

    process{

        switch ([bool]$DattoRMMModuleAccessToken.access_token) {
            $true   { $DattoRMMModuleAccessToken }
            $false  { Write-Warning "The DattoRMM access token is not set. Run Request-DattoRMMAccessToken to set the access token" }
        }

    }

    end {}

}