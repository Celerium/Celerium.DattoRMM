function Get-DattoRMMSite {
<#
    .SYNOPSIS
        Gets data of the site (including total number of devices)
        identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSite cmdlet gets data of the site
        (including total number of devices) identified by the given site Uid

    .PARAMETER SiteUID
        Gets data of a  specific site identified by the given site Uid

    .EXAMPLE
        Get-DattoRMMSite

        Prompts for a site Uid and gets data of the site

    .EXAMPLE
        Get-DattoRMMSite -SiteUID '123456789'

        Gets data for the specific site Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSite.html

    .LINK
        https://zinfandel-api.centrastage.net/api/swagger-ui/index.html
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

        $ResourceUri = "/site/$SiteUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
