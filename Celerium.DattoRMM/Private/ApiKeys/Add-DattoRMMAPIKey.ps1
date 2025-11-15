function Add-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls

    .DESCRIPTION
        The Add-DattoRMMAPIKey cmdlet sets your API key which is used to
        authenticate all API calls made to DattoRMM

        DattoRMM API keys can be generated via the DattoRMM web interface
            Setup > Users > {user} > API

    .PARAMETER ApiKey
        Plain text API key

    .PARAMETER ApiSecretKey
        Plain text API secret key

        If not defined the cmdlet will prompt you to enter the API secret key which
        will be stored as a SecureString

    .PARAMETER ApiKeySecureString
        Input a SecureString object containing the API key

    .EXAMPLE
        Add-DattoRMMAPIKey -ApiKey '12345'

        Prompts to enter in the API secret key which will be stored as a SecureString

    .EXAMPLE
        Add-DattoRMMAPIKey -ApiKey '12345' -ApiSecretKey '12345'

        Converts the string to a SecureString and stores it in the global variable

    .EXAMPLE
        'Celerium@Celerium.org' | Add-DattoRMMAPIKey -ApiKey '12345'

        Converts the string to a SecureString and stores it in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'AsPlainText')]
    [Alias('Set-DattoRMMAPIKey')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'AsPlainText')]
        [AllowEmptyString()]
        [string]$ApiSecretKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'SecureString')]
        [ValidateNotNullOrEmpty()]
        [securestring]$ApiKeySecureString
    )

    begin {}

    process{

        switch ($PSCmdlet.ParameterSetName) {

            'AsPlainText' {

                if ($ApiSecretKey) {
                    $SecureString = ConvertTo-SecureString $ApiSecretKey -AsPlainText -Force

                    Set-Variable -Name "DattoRMMModuleApiKey"       -Value $ApiKey -Option ReadOnly -Scope Global -Force
                    Set-Variable -Name "DattoRMMModuleApiSecretKey" -Value $SecureString -Option ReadOnly -Scope Global -Force
                }
                else {
                    Write-Output "Please enter your API key:"
                    $SecureString = Read-Host -AsSecureString

                    Set-Variable -Name "DattoRMMModuleApiKey"       -Value $ApiKey -Option ReadOnly -Scope Global -Force
                    Set-Variable -Name "DattoRMMModuleApiSecretKey" -Value $SecureString -Option ReadOnly -Scope Global -Force
                }

            }

            'SecureString' {

                Set-Variable -Name "DattoRMMModuleApiKey"       -Value $ApiKey -Option ReadOnly -Scope Global -Force
                Set-Variable -Name "DattoRMMModuleApiSecretKey" -Value $ApiKeySecureString -Option ReadOnly -Scope Global -Force

            }

        }

    }

    end {}

}