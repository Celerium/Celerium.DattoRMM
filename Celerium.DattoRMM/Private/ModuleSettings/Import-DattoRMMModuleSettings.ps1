function Import-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Imports the DattoRMM BaseURI, API, & JSON configuration information to the current session

    .DESCRIPTION
        The Import-DattoRMMModuleSettings cmdlet imports the DattoRMM BaseURI, API, & JSON configuration
        information stored in the DattoRMM configuration file to the users current session

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigPath
        Define the location to store the DattoRMM configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigFile
        Define the name of the DattoRMM configuration file

        By default the configuration file is named:
            config.psd1

    .PARAMETER SkipRequestToken
        Skips requesting an access token

    .EXAMPLE
        Import-DattoRMMModuleSettings

        Validates that the configuration file created with the Export-DattoRMMModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The default location of the DattoRMM configuration file is:
            $env:USERPROFILE\Celerium.DattoRMM\config.psd1

    .EXAMPLE
        Import-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1

        Validates that the configuration file created with the Export-DattoRMMModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The location of the DattoRMM configuration file in this example is:
            C:\Celerium.DattoRMM\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Import-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [string]$DattoRMMConfigFile = 'config.psd1',

        [Parameter()]
        [switch]$SkipRequestToken

    )

    begin {
        $DattoRMMConfig = Join-Path -Path $DattoRMMConfigPath -ChildPath $DattoRMMConfigFile

        $ModuleVersion = $MyInvocation.MyCommand.Version.ToString()

        switch ($PSVersionTable.PSEdition){
            'Core'      { $UserAgent = "Celerium.DattoRMM/$ModuleVersion - PowerShell/$($PSVersionTable.PSVersion) ($($PSVersionTable.Platform) $($PSVersionTable.OS))" }
            'Desktop'   { $UserAgent = "Celerium.DattoRMM/$ModuleVersion - WindowsPowerShell/$($PSVersionTable.PSVersion) ($($PSVersionTable.BuildVersion))" }
            default     { $UserAgent = "Celerium.DattoRMM/$ModuleVersion - $([Microsoft.PowerShell.Commands.PSUserAgent].GetMembers('Static, NonPublic').Where{$_.Name -eq 'UserAgent'}.GetValue($null,$null))" }
        }

    }

    process {

        if (Test-Path $DattoRMMConfig) {
            $TempConfig = Import-LocalizedData -BaseDirectory $DattoRMMConfigPath -FileName $DattoRMMConfigFile

            $TempConfig.DattoRMMModuleApiSecretKey = ConvertTo-SecureString $TempConfig.DattoRMMModuleApiSecretKey

            Set-Variable -Name "DattoRMMModuleBaseUri"              -Value $TempConfig.DattoRMMModuleBaseUri                -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleBaseApiUri"           -Value $TempConfig.DattoRMMModuleBaseApiUri             -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleApiKey"               -Value $TempConfig.DattoRMMModuleApiKey                 -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleApiSecretKey"         -Value $TempConfig.DattoRMMModuleApiSecretKey           -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleUserAgent"            -Value $TempConfig.DattoRMMModuleUserAgent              -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleJSONConversionDepth"  -Value $TempConfig.DattoRMMModuleJSONConversionDepth    -Option ReadOnly -Scope Global -Force

            if ($SkipRequestToken -eq $false){ Request-DattoRMMAccessToken }

            Write-Verbose "Celerium.DattoRMM Module configuration loaded successfully from [ $DattoRMMConfig ]"

            # Clean things up
            Remove-Variable "TempConfig"
        }
        else {
            Write-Verbose "No configuration file found at [ $DattoRMMConfig ] run Add-DattoRMMAPIKey, Add-DattoRMMBaseUri, & Request-DattoRMMAccessToken to get started"

            Set-Variable -Name "DattoRMMModuleUserAgent" -Value $UserAgent -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleJSONConversionDepth" -Value 100 -Scope Global -Force
        }

    }

    end {}

}