function Remove-DattoRMMSiteVariable {
<#
    .SYNOPSIS
        Deletes the site variable identified by the given site Uid and variable Id

    .DESCRIPTION
        The Remove-DattoRMMSiteVariable cmdlet deletes the site variable
        identified by the given site Uid and variable Id

    .PARAMETER SiteUID
        UID of the site

    .PARAMETER VariableID
        ID of the variable

    .EXAMPLE
        Remove-DattoRMMSiteVariable -SiteUID 12345 -VariableID 12345

        Deletes the site variable identified by the given site Uid and variable Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Delete', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

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

        $ResourceUri = "/site/$SiteUID/variable/$VariableID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
