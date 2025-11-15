function Get-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Gets the saved DattoRMM configuration settings

    .DESCRIPTION
        The Get-DattoRMMModuleSettings cmdlet gets the saved DattoRMM configuration settings
        from the local system

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

    .PARAMETER OpenConfigFile
        Opens the DattoRMM configuration file

    .EXAMPLE
        Get-DattoRMMModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-DattoRMMModuleSettings

        The default location of the DattoRMM configuration file is:
            $env:USERPROFILE\Celerium.DattoRMM\config.psd1

    .EXAMPLE
        Get-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the DattoRMM configuration file in this example is:
            C:\Celerium.DattoRMM\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [string]$DattoRMMConfigFile = 'config.psd1',

        [Parameter()]
        [switch]$OpenConfigFile
    )

    begin {
        $DattoRMMConfig = Join-Path -Path $DattoRMMConfigPath -ChildPath $DattoRMMConfigFile
    }

    process {

        if (Test-Path -Path $DattoRMMConfig) {

            if($OpenConfigFile) {
                Invoke-Item -Path $DattoRMMConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $DattoRMMConfigPath -FileName $DattoRMMConfigFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $DattoRMMConfig ]"
        }

    }

    end {}

}