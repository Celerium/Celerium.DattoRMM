function Remove-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Removes the stored DattoRMM configuration folder

    .DESCRIPTION
        The Remove-DattoRMMModuleSettings cmdlet removes the DattoRMM folder and its files
        This cmdlet also has the option to remove sensitive DattoRMM variables as well

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigPath
        Define the location of the DattoRMM configuration folder

        By default the configuration folder is located at:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER AndVariables
        Define if sensitive DattoRMM variables should be removed as well

        By default the variables are not removed

    .EXAMPLE
        Remove-DattoRMMModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does

        The default location of the DattoRMM configuration folder is:
            $env:USERPROFILE\Celerium.DattoRMM

    .EXAMPLE
        Remove-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does
        If sensitive DattoRMM variables exist then they are removed as well

        The location of the DattoRMM configuration folder in this example is:
            C:\Celerium.DattoRMM

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy',SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $DattoRMMConfigPath)  {

            Remove-Item -Path $DattoRMMConfigPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-DattoRMMApiKey
                Remove-DattoRMMBaseUri
            }

            if ($WhatIfPreference -eq $false) {

                if (!(Test-Path $DattoRMMConfigPath)) {
                    Write-Output "The Celerium.DattoRMM configuration folder has been removed successfully from [ $DattoRMMConfigPath ]"
                }
                else {
                    Write-Error "The Celerium.DattoRMM configuration folder could not be removed from [ $DattoRMMConfigPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $DattoRMMConfigPath ]"
        }

    }

    end {}

}