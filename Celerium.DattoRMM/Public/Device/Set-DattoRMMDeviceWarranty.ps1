function Set-DattoRMMDeviceWarranty {
<#
    .SYNOPSIS
        Sets the warranty of a device identified by the given device Uid

    .DESCRIPTION
        The Set-DattoRMMDeviceWarranty cmdlet sets the warranty of a device
        identified by the given device Uid

        The warrantyDate field should be a ISO 8601 string with this format: yyyy-mm-dd
        The warranty date can also be set to null

    .PARAMETER DeviceUID
        The UID of the device to create the quick job on

    .PARAMETER WarrantyDate
        The new warranty date that can also be set to null

        The warrantyDate field should be a ISO 8601 string with this format: yyyy-mm-dd

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        Set-DattoRMMDeviceWarranty -DeviceUID 12345 -WarrantyDate '2025-01-01'

        Sets the warranty of a device identified by the given device Uid

    .EXAMPLE
        Set-DattoRMMDeviceWarranty -DeviceUID 12345 -WarrantyDate $null

        Sets the warranty of a device identified by the given device Uid

    .EXAMPLE
        Set-DattoRMMDeviceWarranty -DeviceUID 12345 -Data $JsonBody

        Creates a quick job on the device with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceWarranty.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true, ParameterSetName = 'Update' )]
        [AllowNull()]
        [Nullable[datetime]]$WarrantyDate,

        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'UpdateData' )]
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

        $ResourceUri = "/device/$DeviceUID/warranty"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Update') {

            $Data = [PSCustomObject]@{
                warrantyDate = if($WarrantyDate){$WarrantyDate.ToString('yyyy-MM-dd')}else{$null}
            }

        }

        #EndRegion  [ Data Construction ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $ParameterData -Value $Data -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
