function Get-DattoRMMAuditESXI {
<#
    .SYNOPSIS
        Fetches audit data of the ESXi host identified the given device Uid

    .DESCRIPTION
        The Get-DattoRMMAuditESXI cmdlet fetches audit data of the
        ESXi host identified the given device Uid

        The device class must be of type "esxihost"

    .PARAMETER DeviceUID
        Return a device with the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditESXI

        Prompts for a specific device uid to get audit data from

    .EXAMPLE
        Get-DattoRMMAuditESXI -DeviceUID '123456789'

        Returns audit data from the specific device uid

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditESXI.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/audit/esxihost/$DeviceUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
