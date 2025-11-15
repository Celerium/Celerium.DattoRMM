function Get-DattoRMMSiteSetting {
<#
    .SYNOPSIS
        Fetches settings of the site identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSiteSetting cmdlet fetches settings of the site
        identified by the given site Uid

    .PARAMETER SiteUID
        Fetches data of a specific site identified by the given site Uid

    .EXAMPLE
        Get-DattoRMMSiteSetting

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSiteSetting -SiteUID '123456789'

        Fetches data for the specific site Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteSetting.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
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

        $ResourceUri = "/site/$SiteUID/settings"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
