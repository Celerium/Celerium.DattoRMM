function New-DattoRMMDeviceJob {
<#
    .SYNOPSIS
        Creates a quick job on the device identified by the given device Uid

    .DESCRIPTION
        The New-DattoRMMDeviceJob cmdlet creates a quick job on
        the device identified by the given device Uid

    .PARAMETER DeviceUID
        The UID of the device to create the quick job on

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        New-DattoRMMDeviceJob -DeviceUID 12345 -Data $JsonBody

        Creates a quick job on the device with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/New-DattoRMMDeviceJob.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true, ValueFromPipeline = $true )]
        $Data

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $ParameterData      = $FunctionName + '_Data' -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/device/$DeviceUID/quickjob"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $ParameterData -Value $Data -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method PUT -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
