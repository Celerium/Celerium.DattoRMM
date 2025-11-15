function Get-DattoRMMAccountDevice {
<#
    .SYNOPSIS
        Fetches the devices of the authenticated user's account.

    .DESCRIPTION
        The Get-DattoRMMAccountDevice cmdlet fetches the devices of
        the authenticated user's account

    .PARAMETER FilterId
        Filters results based on the provided device id

        If applied, this filter exclusively determines the results

    .PARAMETER Hostname
        Filters results based on the provided device hostname

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER DeviceType
        Filters results based on the provided device type

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER OperatingSystem
        Filters results based on the provided device OS

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER SiteName
        Filters results based on the provided site name

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountDevice

        Gets the first 250 account sites

    .EXAMPLE
        Get-DattoRMMAccountDevice -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$FilterID,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Hostname,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceType,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OperatingSystem,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteName,

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

        $ResourceUri = "/account/devices"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)              { $UriParameters['page']            = $Page }
            if ($Max)               { $UriParameters['max']             = $Max }
            if ($FilterID)          { $UriParameters['filterId']        = $FilterID }
            if ($Hostname)          { $UriParameters['hostname']        = $Hostname }
            if ($DeviceType)        { $UriParameters['deviceType']      = $DeviceType }
            if ($OperatingSystem)   { $UriParameters['operatingSystem'] = $OperatingSystem }
            if ($SiteName)          { $UriParameters['siteName']        = $SiteName }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
