function Get-DattoRMMDevicePatch {
<#
    .SYNOPSIS
        Gets patch data of the device identified by the given device Uid

    .DESCRIPTION
        The Get-DattoRMMDevicePatch cmdlet gets patch data of the device
        identified by the given device Uid

    .PARAMETER DeviceUID
        Gets data of the device identified by the given device Uid

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
        Get-DattoRMMDevicePatch -DeviceUID 123456789

        Gets all patch data for the device identified by the given device Uid

    .EXAMPLE
        Get-DattoRMMDevicePatch -DeviceUID 123456789 -InstallStatus INSTALLED -Page 2 -Max 5

        Gets the first defined number of items from the defined page for installed patches

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevicePatch.html

    .LINK
        https://zinfandel-api.centrastage.net/api/swagger-ui/index.html
#>

    [CmdletBinding(DefaultParameterSetName = 'GetDevicePatch')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

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

        $ResourceUri = "/device/$DeviceUID/patches"

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
