function Get-DattoRMMAuditPrinter {
<#
    .SYNOPSIS
        Fetches audit data of the printer identified with the given device Uid

    .DESCRIPTION
        The Get-DattoRMMAuditPrinter cmdlet fetches audit data of the
        printer identified the given device Uid

        The device class must be of type "printer"

    .PARAMETER DeviceUID
        Return a device with the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditPrinter

        Prompts for a specific device uid to get audit data from

    .EXAMPLE
        Get-DattoRMMAuditPrinter -DeviceUID '123456789'

        Returns audit data from the specific device uid

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditPrinter.html

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

        $ResourceUri = "/audit/printer/$DeviceUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
