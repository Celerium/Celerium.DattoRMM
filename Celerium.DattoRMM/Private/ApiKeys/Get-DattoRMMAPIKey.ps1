function Get-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Gets the DattoRMM API key

    .DESCRIPTION
        The Get-DattoRMMAPIKey cmdlet gets the DattoRMM API key from
        the global variable and returns it as an object

    .PARAMETER AsPlainText
        Decrypt and return the API key in plain text

    .EXAMPLE
        Get-DattoRMMAPIKey

        Gets the Api & Api secret key and returns them as an object. The
        API secret key is returned as a secure string

    .EXAMPLE
        Get-DattoRMMAPIKey -AsPlainText

        Gets the Api & Api secret key and returns them as an object. The
        API secret key is returned as plain text

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(Mandatory = $false)]
        [switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($DattoRMMModuleApiSecretKey) {

                if ($AsPlainText) {
                    $ApiSecretKey = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DattoRMMModuleApiSecretKey)

                    [PSCustomObject]@{
                        ApiKey          = $DattoRMMModuleApiKey
                        ApiSecretKey    = ( [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ApiSecretKey) ).ToString()
                    }
                }
                else {
                    [PSCustomObject]@{
                        ApiKey          = $DattoRMMModuleApiKey
                        ApiSecretKey    = $DattoRMMModuleApiSecretKey
                    }
                }

            }
            else { Write-Warning "The DattoRMM API secret key is not set. Run Add-DattoRMMAPIKey to set the API key" }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($ApiSecretKey) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiSecretKey)
            }
        }


    }

    end {}

}