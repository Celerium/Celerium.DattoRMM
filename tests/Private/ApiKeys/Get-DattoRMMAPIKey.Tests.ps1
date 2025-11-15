<#
    .SYNOPSIS
        Pester tests for the Celerium.DattoRMM apiKeys functions

    .DESCRIPTION
        Pester tests for the Celerium.DattoRMM apiKeys functions

    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\apiKeys\Get-DattoRMMAPIKey.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\apiKeys\Get-DattoRMMAPIKey.Tests.ps1 -Output Detailed

        Runs a pester test and outputs detailed results

    .INPUTS
        N/A

    .OUTPUTS
        N/A

    .NOTES
        N/A

    .LINK
        https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.6.1' }

#Region     [ Parameters ]

#Available in Discovery & Run
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$moduleName = 'Celerium.DattoRMM',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$version,

    [Parameter(Mandatory=$true)]
    [ValidateSet('built','notBuilt')]
    [string]$buildTarget
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }
        else{
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }

        switch ($buildTarget) {
            'built'     { $modulePath = Join-Path -Path $rootPath -ChildPath "\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = Join-Path -Path $rootPath -ChildPath "$moduleName" }
        }

        if (Get-Module -Name $moduleName) {
            Remove-Module -Name $moduleName -Force
        }

        $modulePsd1 = Join-Path -Path $modulePath -ChildPath "$moduleName.psd1"

        Import-Module -Name $modulePsd1 -ErrorAction Stop -ErrorVariable moduleError *> $null

        if ($moduleError) {
            $moduleError
            exit 1
        }

    }

    AfterAll{

        Remove-DattoRMMAPIKey -WarningAction SilentlyContinue

        if (Get-Module -Name $moduleName) {
            Remove-Module -Name $moduleName -Force
        }

    }

#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $pester_TestName = (Get-Item -Path $PSCommandPath).Name
        $commandName = $pester_TestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]

Describe "Testing [ $commandName ] function with [ $pester_TestName ]" -Tag @('apiKeys') {

    Context "[ $commandName ] testing function" {

        It "When both parameter [ -ApiKey ] is called it should not return empty" {
            Add-DattoRMMAPIKey -ApiKey '12345' -ApiSecretKey '12345'
            Get-DattoRMMAPIKey | Should -Not -BeNullOrEmpty
        }

        It "Pipeline  - [ -ApiKey ] should return a secure string" {
            "DattoRMMAPIKey" | Add-DattoRMMAPIKey -ApiSecretKey '12345'
            (Get-DattoRMMAPIKey).ApiSecretKey | Should -BeOfType SecureString
        }

        It "Parameter - [ -ApiKey ] should return a secure string" {
            Add-DattoRMMAPIKey -ApiKey '12345' -ApiSecretKey '12345'
            (Get-DattoRMMAPIKey).ApiSecretKey | Should -BeOfType SecureString
        }

        It "Using [ -AsPlainText ] should return [ -ApiKey ] as a string" {
            Add-DattoRMMAPIKey -ApiKey '12345' -ApiSecretKey '12345'
            (Get-DattoRMMAPIKey -AsPlainText).ApiSecretKey | Should -BeOfType String
        }

        It "Using [ -AsPlainText ] should return the API key entered" {
            Add-DattoRMMApiKey -ApiKey '12345' -ApiSecretKey '12345'
            (Get-DattoRMMApiKey -AsPlainText).ApiKey | Should -Be '12345'
        }

        It "If [ -ApiKey ] is empty it should throw a warning" {
            Remove-DattoRMMAPIKey
            Get-DattoRMMAPIKey -WarningAction SilentlyContinue -WarningVariable apiKeyWarning
            [bool]$apiKeyWarning | Should -BeTrue
        }

    }

}