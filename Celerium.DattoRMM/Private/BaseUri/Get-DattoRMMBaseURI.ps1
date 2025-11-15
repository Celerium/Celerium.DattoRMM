function Get-DattoRMMBaseURI {
<#
    .SYNOPSIS
        Shows the DattoRMM base URI

    .DESCRIPTION
        The Get-DattoRMMBaseURI cmdlet shows the DattoRMM base URI from
        the global variable

    .PARAMETER AndApiUri
        Also include the default Api version uri

    .EXAMPLE
        Get-DattoRMMBaseURI

        Shows the DattoRMM base URI value defined in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMBaseURI.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(Mandatory = $false)]
        [switch]$AndApiUri
    )

    begin {}

    process {

        switch ([bool]$DattoRMMModuleBaseUri) {
            $true   {
                if ($AndApiUri) { $DattoRMMModuleBaseUri + $DattoRMMModuleBaseApiUri }
                else { $DattoRMMModuleBaseUri }
            }
            $false  { Write-Warning "The DattoRMM base URI is not set. Run Add-DattoRMMBaseURI to set the base URI." }
        }

    }

    end {}

}