function Export-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Exports the DattoRMM BaseURI, API, & JSON configuration information to file

    .DESCRIPTION
        The Export-DattoRMMModuleSettings cmdlet exports the DattoRMM BaseURI, API, & JSON configuration information to file

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
        This means that you cannot copy your configuration file to another computer or user account and expect it to work

    .PARAMETER DattoRMMConfigPath
        Define the location to store the DattoRMM configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigFile
        Define the name of the DattoRMM configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-DattoRMMModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's DattoRMM configuration file located at:
            $env:USERPROFILE\Celerium.DattoRMM\config.psd1

    .EXAMPLE
        Export-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's DattoRMM configuration file located at:
            C:\Celerium.DattoRMM\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Export-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [string]$DattoRMMConfigFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $DattoRMMConfig = Join-Path -Path $DattoRMMConfigPath -ChildPath $DattoRMMConfigFile

        $GlobalModuleVariables = @('DattoRMMModuleBaseUri', 'DattoRMMModuleBaseApiUri', 'DattoRMMModuleApiKey', 'DattoRMMModuleApiSecretKey', 'DattoRMMModuleUserAgent', 'DattoRMMModuleJSONConversionDepth')
        foreach ($GlobalVariable in  $GlobalModuleVariables) {
            if (-not (Get-Variable -Name $GlobalVariable -ErrorAction SilentlyContinue -ErrorVariable GlobalVariableCheck)){
                Write-Error "The required module variable [ $GlobalVariable ] is not set"
            }
        }

        # Confirm variables exist and are not null before exporting
        if (-not $GlobalVariableCheck) {
            $SecureString = $DattoRMMModuleApiSecretKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $DattoRMMConfigPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $DattoRMMConfigPath -ItemType Directory -Force
            }
@"
    @{
        DattoRMMModuleBaseUri             = '$DattoRMMModuleBaseUri'
        DattoRMMModuleBaseApiUri          = '$DattoRMMModuleBaseApiUri'
        DattoRMMModuleApiKey              = '$DattoRMMModuleApiKey'
        DattoRMMModuleApiSecretKey        = '$SecureString'
        DattoRMMModuleUserAgent           = '$DattoRMMModuleUserAgent'
        DattoRMMModuleJSONConversionDepth = '$DattoRMMModuleJSONConversionDepth'
    }
"@ | Out-File -FilePath $DattoRMMConfig -Force
        }
        else {
            Write-Error "Failed to export DattoRMM Module settings to [ $DattoRMMConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}