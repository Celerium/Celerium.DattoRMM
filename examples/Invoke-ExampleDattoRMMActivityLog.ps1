<#
    .SYNOPSIS
        Gets example data using the Celerium.DattoRMM module

    .DESCRIPTION
        The Invoke-ExampleDattoRMMActivityLog script gets example
        data using the various methods available to an endpoint

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to DattoRMM

    .PARAMETER APISecretKey
        Defines the APISecretKey used to authenticate to DattoRMM

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .EXAMPLE
        .\Invoke-ExampleDattoRMMActivityLog.ps1

        Pulls example data using the various activity log function scripts to
        test basic functionality of the API calls

        No progress information is sent to the console while the script is running

    .NOTES
        N/A

    .INPUTS
        N/A

    .OUTPUTS
        Console

    .LINK
        https://github.com/Celerium/Celerium.DattoRMM

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 3.0
<# #Requires -Modules @{ ModuleName='Celerium.DattoRMM'; ModuleVersion='2.2.0' } #>

#Region     [ Parameters ]

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$APIKey,

        [Parameter()]
        [string]$APISecretKey,

        [Parameter()]
        [string]$APIUri

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/2) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1

    #Import-Module Celerium.DattoRMM -Verbose:$false

    #Setting up DattoRMM APIKey & BaseURI
    try {

        if ($APIKey -and $APISecretKey) {
            Add-DattoRMMAPIKey -ApiKey $APIKey -ApiSecretKey $APISecretKey
            Request-DattoRMMAccessToken
        }
        if([bool]$(Get-DattoRMMAPIKey -WarningAction SilentlyContinue) -eq $false) {
            Throw "The DattoRMM API keys are not set. Run Add-DattoRMMAPIKey to set the API keys"
        }

        if ($APIUri) { Add-DattoRMMBaseURI -BaseUri $APIUri }else{Add-DattoRMMBaseURI -DataCenter Zinfandel}
        if([bool]$(Get-DattoRMMBaseURI -WarningAction SilentlyContinue) -eq $false) {
            Throw "The DattoRMM API base URI is not set. Run Add-DattoRMMBaseURI to set the base URI"
        }

    }
    catch {
        Write-Error $_
        exit 1
    }


#EndRegion  [ Prerequisites ]

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Find existing examples"
    $StepNumber++

#Region     [ Example Code ]

    $Params = @{
        Size    = 20..100 | Get-Random -Count 1
        Order   = 'asc','desc' | Get-Random -Count 1
        from    = (Get-Date).AddDays($(-7..-30 | Get-Random -Count 1)).ToString('yyyy-MM-ddTHH:mm:ssZ')
        until   = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssZ')
        entities= 'device','user' | Get-Random -Count 1
    }

    $DattoRMMActivityLogReturn = (Get-DattoRMMActivityLog @Params).data

#EndRegion  [ Example Code ]

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $DattoRMMActivityLogReturn -Scope Global -Force

    $DattoRMMActivityLogReturn
    $Params | Out-String

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''