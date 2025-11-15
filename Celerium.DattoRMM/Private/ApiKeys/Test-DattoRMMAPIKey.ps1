function Test-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Test the DattoRMM API key

    .DESCRIPTION
        The Test-DattoRMMAPIKey cmdlet tests the base URI & API key that are defined
        in the Add-DattoRMMBaseURI & Add-DattoRMMAPIKey cmdlets

        Helpful when needing to validate general functionality or when using
        RMM deployment tools

        The DattoRMM status endpoint is called in this test

    .PARAMETER BaseUri
        Define the base URI for the DattoRMM API connection
        using DattoRMM's URI or a custom URI

        By default the value used is the one defined by the
        Add-DattoRMMBaseURI function

    .EXAMPLE
        Test-DattoRMMAPIKey

        Tests the base URI & API key that are defined in the
        Add-DattoRMMBaseURI & Add-DattoRMMAPIKey cmdlets

    .EXAMPLE
        Test-DattoRMMAPIKey -BaseUri http://myapi.gateway.celerium.org

        Tests the defined base URI & API key that was defined in
        the Add-DattoRMMAPIKey cmdlet

        The full base uri test path in this example is:
            http://myapi.gateway.celerium.org/regions

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Test-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Test')]
    Param (
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUri = $DattoRMMModuleBaseUri
    )

    begin { $ResourceUri = "/system/status" }

    process {

        Write-Verbose "Testing API key against [ $($BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI) ]"

        try {

            if ([bool]$DattoRMMModuleAccessToken.access_token -eq $false) { Request-DattoRMMAccessToken -ErrorAction Stop }
            $Headers = @{ 'Authorization' = "Bearer $($DattoRMMModuleAccessToken.access_token)" }

            $Parameters = @{
                'Method'    = 'GET'
                'Uri'       = $BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI
                'Headers'   = $Headers
                'UserAgent' = $DattoRMMModuleUserAgent
            }

            $rest_output = Invoke-WebRequest @Parameters -ErrorAction Stop

        }
        catch {

            [PSCustomObject]@{
                Method              = $_.Exception.Response.Method
                StatusCode          = $_.Exception.Response.StatusCode.value__
                StatusDescription   = $_.Exception.Response.StatusDescription
                Message             = $_.Exception.Message
                URI                 = $($BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI)
            }

        } finally {
            [void] ($Headers.Remove('Authorization'))
        }

        if ($rest_output) {
            $Data = @{}
            $Data = $rest_output

            [PSCustomObject]@{
                StatusCode          = $Data.StatusCode
                StatusDescription   = $Data.StatusDescription
                URI                 = $($BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI)
            }
        }

    }

    end {}

}