function Set-DattoRMMAlert {
<#
    .SYNOPSIS
        Updates (resolves) an alert

    .DESCRIPTION
        The Set-DattoRMMAlert cmdlet updates (resolves) an alert

    .PARAMETER AlertUID
        UID of the alert

    .EXAMPLE
        Set-DattoRMMAlert -AlertUID 12345

        Updates (resolves) the alert with the defined Uid

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Alert/Set-DattoRMMAlert.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$AlertUID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/alert/$AlertUID/resolve"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method POST -ResourceURI $ResourceUri
        }

    }

    end {}

}
