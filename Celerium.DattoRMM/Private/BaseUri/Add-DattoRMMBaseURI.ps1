function Add-DattoRMMBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the DattoRMM API connection

    .DESCRIPTION
        The Add-DattoRMMBaseURI cmdlet sets the base URI which is used
        to construct the full URI for all API calls

    .PARAMETER BaseUri
        Sets the base URI for the DattoRMM API connection. Helpful
        if using a custom API gateway

    .PARAMETER BaseApiUri
        Sets the base Api URI for the DattoRMM API connection

    .PARAMETER DataCenter
        Defines the data center (platform) to use which in turn defines which
        base API URL is used

        Allowed values:
        'Pinotage', 'Merlot', 'Concord', 'Vidal', 'Zinfandel', 'Syrah'

            'Pinotage'  = 'https://pinotage-api.centrastage.net'
            'Merlot'    = 'https://merlot-api.centrastage.net'
            'Concord'   = 'https://concord-api.centrastage.net'
            'Vidal'     = 'https://vidal-api.centrastage.net'
            'Zinfandel' = 'https://zinfandel-api.centrastage.net'
            'Syrah'     = 'https://syrah-api.centrastage.net'

    .EXAMPLE
        Add-DattoRMMBaseURI

        You will be prompted to select a data center

    .EXAMPLE
        Add-DattoRMMBaseURI -BaseUri 'https://gateway.celerium.org'

        The base URI will use https://gateway.celerium.org

    .EXAMPLE
        'https://gateway.celerium.org' | Add-DattoRMMBaseURI

        The base URI will use https://gateway.celerium.org

    .EXAMPLE
        Add-DattoRMMBaseURI -DataCenter Pinotage

        The base URI will use https://pinotage-api.centrastage.net

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMBaseURI.html
#>

    [CmdletBinding(DefaultParameterSetName = 'PreDefinedUri')]
    [Alias('Set-DattoRMMBaseURI')]
    Param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'CustomUri')]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUri,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseApiUri = '/api/v2',

        [parameter(Mandatory = $true, ParameterSetName = 'PreDefinedUri')]
        [ValidateSet( 'Pinotage', 'Merlot', 'Concord', 'Vidal', 'Zinfandel', 'Syrah')]
        [Alias('Platform')]
        [string]$DataCenter
    )

    begin {}

    process{

        if($BaseUri[$BaseUri.Length-1] -eq "/") {
            $BaseUri = $BaseUri.Substring(0,$BaseUri.Length-1)
        }

        switch ($DataCenter) {
            'Pinotage'  { $BaseUri = 'https://pinotage-api.centrastage.net'  }
            'Merlot'    { $BaseUri = 'https://merlot-api.centrastage.net'    }
            'Concord'   { $BaseUri = 'https://concord-api.centrastage.net'   }
            'Vidal'     { $BaseUri = 'https://vidal-api.centrastage.net'     }
            'Zinfandel' { $BaseUri = 'https://zinfandel-api.centrastage.net' }
            'Syrah'     { $BaseUri = 'https://syrah-api.centrastage.net'     }
            Default {}
        }

        Set-Variable -Name "DattoRMMModuleBaseUri" -Value $BaseUri -Option ReadOnly -Scope Global -Force
        Set-Variable -Name "DattoRMMModuleBaseApiUri" -Value $BaseApiUri -Option ReadOnly -Scope Global -Force

    }

    end {}

}