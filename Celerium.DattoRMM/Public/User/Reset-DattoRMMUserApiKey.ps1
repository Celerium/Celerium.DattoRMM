function Reset-DattoRMMUserApiKey {
<#
    .SYNOPSIS
        Resets the authenticated user's API access and secret keys

    .DESCRIPTION
        The Reset-DattoRMMUserApiKey cmdlet resets the authenticated user's
        API access and secret keys

        This will return the new access & secret keys

    .EXAMPLE
        Reset-DattoRMMUserApiKey

        Resets the authenticated user's API access and secret keys
        and returns them to the console

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/User/Reset-DattoRMMUserApiKey.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Reset', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/user/resetApiKeys"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method POST -ResourceURI $ResourceUri
        }

    }

    end {}

}
