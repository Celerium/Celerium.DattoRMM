function Get-DattoRMMAccount {
<#
    .SYNOPSIS
        Gets the authenticated user's account data.

    .DESCRIPTION
        The Get-DattoRMMAccount cmdlet gets the authenticated
        user's account data

    .EXAMPLE
        Get-DattoRMMAccount

        Gets the authenticated user's account data

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccount.html

    .LINK
        https://zinfandel-api.centrastage.net/api/swagger-ui/index.html
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
