function Set-DattoRMMSiteVariable {
<#
    .SYNOPSIS
        Updates the site variable identified by the given
        site Uid and variable Id

    .DESCRIPTION
        The Set-DattoRMMSiteVariable cmdlet updates the site variable
        identified by the given site Uid and variable Id

    .PARAMETER SiteUID
        UID of the site

    .PARAMETER VariableID
        ID of the variable

    .PARAMETER Name
        Name of the variable

    .PARAMETER Value
        Value of the variable

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        Set-DattoRMMSiteVariable -SiteUID 12345 -VariableID 12345 -Name 'NewVariableName' -Value 'NewVariableValue'

        Updates the site variable with the defined data

    .EXAMPLE
        Set-DattoRMMSiteVariable -Data $JsonBody

        Updates the site variable with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [int64]$VariableID,

        [Parameter( Mandatory = $true, ParameterSetName = 'Update' )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter( Mandatory = $true, ParameterSetName = 'Update' )]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

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

        $ResourceUri = "/site/$SiteUID/variable/$VariableID"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Update') {

            $Data = [PSCustomObject]@{
                name    = $Name
                value   = $Value
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
