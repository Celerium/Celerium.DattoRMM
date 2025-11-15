function Get-DattoRMMAuditDevice {
<#
    .SYNOPSIS
        Fetches audit data of the generic device identified the given device Uid

    .DESCRIPTION
        The Get-DattoRMMAuditDevice cmdlet fetches audit data of the
        generic device identified the given device Uid

        The device class must be of type "device"

    .PARAMETER DeviceUID
        Fetches audit data of the generic device identified
        the given device Uid

    .PARAMETER Software
        Fetches audited software of the generic device identified
        the given device Uid

    .PARAMETER MacAddress
        Fetches audit data of the generic device(s) identified by the given
        MAC address in format: XXXXXXXXXXXX

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAuditDevice

        Prompts for a specific device uid to get audit data from

    .EXAMPLE
        Get-DattoRMMAuditDevice -DeviceUID '123456789'

        Returns audit data from the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditDevice -DeviceUID '123456789' -Software

        Returns software audit data from the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditDevice -MacAddress '00155DC07E1F'

        Returns audit data from the specific device with the given MAC address

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'DeviceOnly')]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceOnly' )]
        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceSoftware' )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $false,  ParameterSetName = 'DeviceSoftware' )]
        [switch]$Software,

        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceMacAddress' )]
        [ValidateNotNullOrEmpty()]
        [string]$MacAddress,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceSoftware' )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceSoftware' )]
        [ValidateRange(1, 250)]
        [int]$Max = 250,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceSoftware' )]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'DeviceOnly'        { $ResourceUri = "/audit/device/$DeviceUID" }
            'DeviceSoftware'    { $ResourceUri = "/audit/device/$DeviceUID/software" }
            'DeviceMacAddress'  { $ResourceUri = "/audit/device/macAddress/$MacAddress" }

        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'DeviceSoftware') {
            if ($Page)  { $UriParameters['page']    = $Page }
            if ($Max)   { $UriParameters['max']     = $Max }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter:$UriParameters -AllResults:$AllResults

    }

    end {}

}
