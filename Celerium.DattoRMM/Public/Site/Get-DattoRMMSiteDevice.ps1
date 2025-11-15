function Get-DattoRMMSiteDevice {
<#
    .SYNOPSIS
        Fetches the devices records of the site identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSiteDevice cmdlet fetches the devices records of the
        site identified by the given site Uid

    .PARAMETER SiteUID
        Fetches data of a specific site identified by the given site Uid

    .PARAMETER FilterID
        Fetches data of a specific site device identified by the given device Id

    .PARAMETER NetworkInterface
        Fetches the shortened devices records with network interface information
        of the site identified by the given site Uid

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMSiteDevice

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSiteDevice -SiteUID '123456789'

        Fetches data for the specific site Id

    .EXAMPLE
        Get-DattoRMMAccountAlert -SiteUID '123456789' -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'DeviceOnly')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceOnly' )]
        [ValidateNotNullOrEmpty()]
        [string]$FilterID,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceNetworkInterface' )]
        [switch]$NetworkInterface,

        [Parameter( Mandatory = $false )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page,

        [Parameter( Mandatory = $false )]
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

        switch ($PSCmdlet.ParameterSetName){
            'DeviceOnly'                { $ResourceUri = "/site/$SiteUID/devices" }
            'DeviceNetworkInterface'    { $ResourceUri = "/site/$SiteUID/devices/network-interface" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($Page)  { $UriParameters['page']    = $Page }
        if ($Max)   { $UriParameters['max']     = $Max }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter:$UriParameters -AllResults:$AllResults

    }

    end {}

}
