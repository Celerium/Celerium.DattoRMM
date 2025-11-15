function New-DattoRMMSite {
<#
    .SYNOPSIS
        Creates a new site in the authenticated user's account

    .DESCRIPTION
        The New-DattoRMMSite cmdlet creates a new site in
        the authenticated user's account

    .PARAMETER Name
        Name of the site

    .PARAMETER Description
        Description of the site

    .PARAMETER Note
        Note for the site

    .PARAMETER OnDemand
        Is the site OnDemand

        By default, if this switch is not specified, the site with be set to managed

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        New-DattoRMMSite -Name 'SiteName' -Description 'Example Site'

        Create a new managed site account with the defined data

    .EXAMPLE
        New-DattoRMMSite -Data $JsonBody

        Create a new managed site account with with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/New-DattoRMMSite.html

#>

    [CmdletBinding(DefaultParameterSetName = 'CreateData', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'Create')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter( Mandatory = $false, ParameterSetName = 'Create' )]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter( Mandatory = $false, ParameterSetName = 'Create' )]
        [ValidateNotNullOrEmpty()]
        [string]$Note,

        [Parameter( Mandatory = $false, ParameterSetName = 'Create' )]
        [switch]$OnDemand,

        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'CreateData' )]
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

        $ResourceUri = "/site"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Create') {

            $Data = [PSCustomObject]@{
                name        = $Name
                description = $Description
                note        = $Note
                onDemand    = $OnDemand.IsPresent
            }

        }

        #EndRegion  [ Data Construction ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $ParameterData -Value $Data -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method PUT -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
