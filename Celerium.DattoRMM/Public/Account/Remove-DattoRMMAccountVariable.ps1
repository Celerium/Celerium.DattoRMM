function Remove-DattoRMMAccountVariable {
<#
    .SYNOPSIS
        Deletes an account variable

    .DESCRIPTION
        The Remove-DattoRMMAccountVariable cmdlet deletes an account variable

    .PARAMETER VariableID
        ID of the variable

    .EXAMPLE
        Remove-DattoRMMAccountVariable -VariableID 12345

        Deletes the account variable with the defined Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Remove-DattoRMMAccountVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Delete', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [int64]$VariableID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/account/variable/$VariableID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
