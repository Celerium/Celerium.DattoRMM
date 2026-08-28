function Get-DattoRMMSitePatch {
<#
    .SYNOPSIS
        Gets patch data for devices in a given site UID

    .DESCRIPTION
        The Get-DattoRMMSitePatch cmdlet gets patch data for devices in the
        site identified by a given site Uid

    .PARAMETER SiteUID
        Gets patch data for a specific site Uid

    .PARAMETER InstallStatus
        Show patches with the given install status

        Allowed Values:
            'INSTALLED', 'APPROVED_PENDING', 'NOT_APPROVED'

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMSitePatch -SiteUID '123456789'

        Gets patch data for devices in the defined site UID

    .EXAMPLE
        Get-DattoRMMSitePatch -SiteUID '123456789' -InstallStatus 'INSTALLED' -Page 2 -Max 5

        Gets the first defined number of items from the defined page for installed patches

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSitePatch.html

    .LINK
        https://zinfandel-api.centrastage.net/api/swagger-ui/index.html
#>

    [CmdletBinding(DefaultParameterSetName = 'GetSitePatch')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $false )]
        [ValidateSet('INSTALLED', 'APPROVED_PENDING', 'NOT_APPROVED')]
        [string]$InstallStatus,

        [Parameter( Mandatory = $false )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page,

        [Parameter( Mandatory = $false)]
        [ValidateRange(1, 250)]
        [int]$Max = 250,

        [Parameter( Mandatory = $false )]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/site/$SiteUID/patches"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($InstallStatus) { $UriParameters['installStatus']   = $InstallStatus }
        if ($Page)          { $UriParameters['page']            = $Page }
        if ($Max)           { $UriParameters['max']             = $Max }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter:$UriParameters -AllResults:$AllResults

    }

    end {}

}
