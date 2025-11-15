function Set-DattoRMMSite {
<#
    .SYNOPSIS
        Updates the site identified by the given site Uid

    .DESCRIPTION
        The Set-DattoRMMSite cmdlet updates the site
        identified by the given site Uid

    .PARAMETER SiteUID
        UID of the site

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
        Set-DattoRMMSite -SiteID 12345 -Name 'NewSiteName' -Description 'NewDescription'

        Updates the site with the defined data

    .EXAMPLE
        Set-DattoRMMSite -Data $JsonBody

        Updates the site with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSite.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [ValidateNotNullOrEmpty()]
        [string]$Note,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [switch]$OnDemand,

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

        $ResourceUri = "/site/$SiteUID"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Update') {

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
            return Invoke-DattoRMMRequest -Method POST -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
