function Remove-DattoRMMSiteProxy {
<#
    .SYNOPSIS
        Deletes site proxy settings for the site identified by the given site Uid

    .DESCRIPTION
        The Remove-DattoRMMSiteProxy cmdlet deletes site proxy settings
        for the site identified by the given site Uid

    .PARAMETER SiteUID
        UID of the site

    .EXAMPLE
        Remove-DattoRMMSiteProxy -SiteUID 12345

        Deletes the site proxy settings with the defined Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteProxy.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Delete', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/site/$SiteUID/settings/proxy"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
