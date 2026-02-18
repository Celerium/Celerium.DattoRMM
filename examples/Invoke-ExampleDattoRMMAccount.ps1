<#
    .SYNOPSIS
        Populates example data using the Celerium.DattoRMM module

    .DESCRIPTION
        The Invoke-ExampleDattoRMMAccount script populates example
        data using the various methods available to an endpoint

        By default on the first run this script will create 5 new account
        variables in a defined organization.
        All subsequent runs will then update various fields of those accounts

        Unless the -Verbose parameter is used, no output is displayed while the script runs

    .PARAMETER APIKey
        Defines the APIKey used to authenticate to DattoRMM

    .PARAMETER APISecretKey
        Defines the APISecretKey used to authenticate to DattoRMM

    .PARAMETER APIUri
        Defines the base uri to use when making API calls

    .PARAMETER RemoveExamples
        Defines if the example data should be deleted

    .PARAMETER RemoveExamplesConfirm
        Defines if the example data should be deleted only when prompted

    .PARAMETER ExamplesToMake
        Defines how many examples to make

    .EXAMPLE
        .\Invoke-ExampleDattoRMMAccount.ps1

        Runs various account function scripts to test basic functionality of the API calls

        Account variables are created/updated with the name [ ExampleAccountVariable-# ]

        API calls are made individually, so if 5 examples are made then 5 API calls are made

        No progress information is sent to the console while the script is running

    .EXAMPLE
        .\Invoke-ExampleDattoRMMOrganization.ps1 -RemoveExamples -RemoveExamplesConfirm -Verbose

        Runs various account function scripts to test basic functionality of the API calls

        Account variables are created/updated with the name [ ExampleAccountVariable-# ]

        API calls are made individually, so if 5 examples are made then 10 API calls are made
        because the examples are also deleted at the end of the script when the
        RemoveExamples parameter is used.

        Progress information is sent to the console while the script is running

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
        [string]$APIUri,

        [Parameter()]
        [switch]$RemoveExamples,

        [Parameter()]
        [switch]$RemoveExamplesConfirm,

        [Parameter()]
        [ValidateRange(1, 100)]
        [int64]$ExamplesToMake = 5

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/3) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1
    $ExampleName    = 'ExampleAccountVariable'

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

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Find existing examples"
    $StepNumber++

#Region     [ Example Code ]

    #Example values
    $ExampleNumber = 1

    $AccountData            = (Get-DattoRMMAccount).data
    $AccountAlertData       = (Get-DattoRMMAccountAlert -AlertType Open -AllResults).data
    $AccountComponentData   = (Get-DattoRMMAccountComponent -AllResults).data
    $AccountDeviceData      = (Get-DattoRMMAccountDevice -AllResults).data
    $AccountDNetData        = (Get-DattoRMMAccountDnetSiteMapping).data | Where-Object {$null -ne $_.dattoNetworkingNetworkIds}
    $AccountSiteData        = (Get-DattoRMMAccountSite -AllResults).data
    $AccountUserData        = (Get-DattoRMMAccountUser -AllResults).data
    $AccountVariableData    = (Get-DattoRMMAccountVariable -AllResults).data

    $ExampleReturnData = [PSCustomObject]@{
        AccountName             = $AccountData.name
        AccountOpenAlerts       = ($AccountAlertData | Measure-Object).Count
        AccountComponents       = ($AccountComponentData | Measure-Object).Count
        AccountDevices          = ($AccountDeviceData | Measure-Object).Count
        AccountDNetSiteMappings = ($AccountDNetData | Measure-Object).Count
        AccountSites            = ($AccountSiteData | Measure-Object).Count
        AccountUsers            = ($AccountUserData | Measure-Object).Count
        AccountVariables        = ($AccountVariableData | Measure-Object).Count
    }

    #Loop to create example data
    while($ExampleNumber -le $ExamplesToMake) {

        $ExampleVariableName = "$ExampleName-$ExampleNumber"

        $ExistingVariable = $AccountVariableData | Where-Object {$_.name -like "$ExampleVariableName*"}

        if ($ExistingVariable) {

            #Example Hashtable
            $UpdatedVariableHashTable = @{
                "name"  = "$ExampleVariableName-$(Get-Date -Format 'yyyy-MM-dd-HHmmss')"
                "value" = New-Guid
            }

            Write-Host "Updating example variable          [ $ExampleVariableName ]" -ForegroundColor Green
            $DattoRMMVariableReturn = Set-DattoRMMAccountVariable -VariableID $ExistingVariable.id -Data $UpdatedVariableHashTable

        }
        else {

            #Example Hashtable
            $NewVariableHashTable = @{
                "name"      = $ExampleVariableName
                "value"     = New-Guid
                "masked"    = $true,$false | Get-Random -Count 1
            }

            Write-Host "Creating example variable          [ $ExampleVariableName ]" -ForegroundColor Green
            $DattoRMMVariableReturn = New-DattoRMMAccountVariable -Data $NewVariableHashTable

        }

        #Clear hashtable's for the next loop
        $UpdatedVariableHashTable   = $null
        $NewVariableHashTable       = $null

        $ExampleNumber++

    }
    #End of Loop

#EndRegion  [ Example Code ]

#Region     [ Example Cleanup ]

if ($RemoveExamples -and $ExampleReturnData) {

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Deleting examples"
    $StepNumber++

    $AccountExampleVariables = (Get-DattoRMMAccountVariable -AllResults).data | Where-Object {$_.name -like "$ExampleName*"}

    if ($RemoveExamplesConfirm) { Read-Host "Press enter to delete [ $( ($AccountExampleVariables | Measure-Object).Count) ] example variables" }

    foreach ($Variable in $AccountExampleVariables) {
        Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Deleting example variable [ $($Variable.name) ]"
        $DeletedData = Remove-DattoRMMAccountVariable -VariableID $Variable.id -Confirm:$false
    }

}

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

    Write-Verbose " - ($StepNumber/3) - $(Get-Date -Format MM-dd-HH:mm) - Done"


#EndRegion  [ Example Cleanup ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''