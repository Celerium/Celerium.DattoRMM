function Get-DattoRMMAccount {
<#
    .SYNOPSIS
        Fetches the authenticated user's account data.

    .DESCRIPTION
        The Get-DattoRMMAccount cmdlet fetches the authenticated
        user's account data

    .EXAMPLE
        Get-DattoRMMAccount

        Fetches the authenticated user's account data

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccount.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/account"

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri

    }

    end {}

}
