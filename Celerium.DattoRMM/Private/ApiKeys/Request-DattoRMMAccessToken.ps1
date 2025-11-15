function Request-DattoRMMAccessToken {
<#
    .SYNOPSIS
        Requests an JWT access token using the users Api keys

    .DESCRIPTION
        The Request-DattoRMMAccessToken cmdlet requests an JWT access token using
        the users Api keys. The JWT token is used to validate all API calls made to DattoRMM

    .PARAMETER ApiUri
        Base URI for the DattoRMM Api connection

    .PARAMETER ApiKey
        Plain text API key

    .PARAMETER ApiSecretKey
        Plain text API secret key

        If not defined the cmdlet will prompt you to enter the API secret key which
        will be stored as a SecureString

    .PARAMETER ApiKeySecureString
        Input a SecureString object containing the API key

    .EXAMPLE
        Request-DattoRMMAccessToken

        Uses all the defined global variables to request an access token

    .EXAMPLE
        Request-DattoRMMAccessToken -ApiUri 'https://gateway.celerium.org' -ApiKey '12345' -ApiSecretKey '12345'

        Using the define values, sets, converts, & adds the values to global variables and requests an access token

    .EXAMPLE
        'Celerium@Celerium.org' | Request-DattoRMMAccessToken -ApiKey '12345' -ApiSecretKey '12345'

        Using the define values, sets, converts, & adds the values to global variables and requests an access token

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Request-DattoRMMAccessToken.html
#>

    [CmdletBinding(DefaultParameterSetName = 'RequestToken')]
    [Alias('Set-DattoRMMAccessToken')]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiUri = $DattoRMMModuleBaseUri,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = $DattoRMMModuleApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiSecretKey = $(Get-DattoRMMAPIKey -AsPlainText).ApiSecretKey

    )

    begin {}

    process{

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]'Tls12'

        $ClientID       = 'public-client'
        $ClientSecret   = ConvertTo-SecureString -String 'public' -AsPlainText -Force

        $InvokeParams = @{
            Credential  = New-Object System.Management.Automation.PSCredential -ArgumentList ($ClientID, $ClientSecret)
            Uri         = "$ApiUri/auth/oauth/token"
            Method      = 'POST'
            ContentType = 'application/x-www-form-urlencoded'
            Body        = "grant_type=password&username=$ApiKey&password=$ApiSecretKey"
        }

        try {
            $AccessTokenResponse = Invoke-RestMethod @InvokeParams

            if ($AccessTokenResponse) {
                Set-Variable -Name "DattoRMMModuleAccessToken" -Value $AccessTokenResponse -Option ReadOnly -Scope Global -Force
            }

        }
        catch {
            Write-Error $_
            exit 1
        }

    }

    end {}

}