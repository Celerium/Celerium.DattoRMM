function Set-DattoRMMSiteProxy {
<#
    .SYNOPSIS
        Creates/updates the proxy settings for the site identified
        by the given site Uid

    .DESCRIPTION
        The Set-DattoRMMSiteProxy cmdlet creates/updates the proxy settings
        for the site identified by the given site Uid

    .PARAMETER SiteUID
        UID of the site

    .PARAMETER ProxyHost
        Proxy host address

    .PARAMETER Port
        Proxy port

    .PARAMETER Type
        Proxy type, this is case sensitive

        Allowed values:
            http
            socks4
            socks5

    .PARAMETER UserName
        Proxy username

    .PARAMETER Password
        Proxy password

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        Set-DattoRMMSiteProxy -SiteUID 12345 -Host proxy.celerium.org -UserName 'Celerium' -Password 'Password' -Port 8080 -Type socks5

        Updates/creates the site proxy settings with the defined data

    .EXAMPLE
        Set-DattoRMMSiteProxy -Data $JsonBody

        Updates/creates the site proxy settings with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteProxy.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $true, ParameterSetName = 'Update' )]
        [ValidateSet( 'http', 'socks4', 'socks5', IgnoreCase = $false )]
        [string]$Type,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [string]$ProxyHost,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [int]$Port,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [string]$UserName,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [string]$Password,

        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'UpdateData' )]
        $Data

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $ParameterData      = $FunctionName + '_Data' -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/site/$SiteUID/settings/proxy"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Update') {

            $Data = [PSCustomObject]@{
                host        = $ProxyHost
                password    = $Password
                port        = $Port
                type        = $Type
                username    = $UserName
            }

        }

        #EndRegion  [ Data Construction ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $ParameterData -Value $Data -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
