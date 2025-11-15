function Get-DattoRMMAlert {
<#
    .SYNOPSIS
        Fetches data of the alert identified by the given alert Uid

    .DESCRIPTION
        The Get-DattoRMMAlert cmdlet fetches data of the alert
        identified by the given alert Uid

    .PARAMETER AlertUID
        Gets alerts from a specific alert udi

    .EXAMPLE
        Get-DattoRMMAlert

        Prompts for a specific alert uid to get the alert data

    .EXAMPLE
        Get-DattoRMMAlert -AlertUID '123456789'

        Gets the alert with the specific alert udi

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Alert/Get-DattoRMMAlert.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true)]
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

        $ResourceUri = "/alert/$AlertUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
