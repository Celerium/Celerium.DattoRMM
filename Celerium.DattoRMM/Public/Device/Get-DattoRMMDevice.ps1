function Get-DattoRMMDevice {
<#
    .SYNOPSIS
        Fetches data of the device identified by the given device Uid

    .DESCRIPTION
        The Get-DattoRMMDevice cmdlet fetches data of the device
        identified by the given device Uid

    .PARAMETER DeviceUID
        Fetches data of the device identified by the given device Uid

    .PARAMETER DeviceID
        Fetches data of the device identified by the given device Id

    .PARAMETER MacAddress
        Fetches data of the device(s) identified by the given MAC address

        Format: XXXXXXXXXXXX

    .EXAMPLE
        Get-DattoRMMDevice

        Prompts for a device Uid and fetches data of the device

    .EXAMPLE
        Get-DattoRMMDevice -DeviceID '123456789'

        Fetches data for the specific device Id

    .EXAMPLE
        Get-DattoRMMDevice -MacAddress '00155DC07E1F'

        Fetches data for the specific device mac address

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'DeviceUID')]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceUID')]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceID')]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceMacAddress')]
        [ValidateNotNullOrEmpty()]
        [string]$MacAddress
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'DeviceUID'     { $ResourceUri = "/device/$DeviceUID" }
            'DeviceID'      { $ResourceUri = "/device/id/$DeviceID" }
            'MacAddress'    { $ResourceUri = "/device/macAddress/$MacAddress" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
