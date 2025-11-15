function New-DattoRMMAccountVariable {
<#
    .SYNOPSIS
        Creates an account variable

    .DESCRIPTION
        The New-DattoRMMAccountVariable cmdlet creates an account variable

    .PARAMETER Name
        Name of the variable

    .PARAMETER Value
        Value of the variable

    .PARAMETER Masked
        Should the value of the variable be masked (hidden)

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        New-DattoRMMAccountVariable -Name 'VariableName' -Value 'VariableValue' -Masked

        Create a new account variable with the defined data

    .EXAMPLE
        New-DattoRMMAccountVariable -Data $JsonBody

        Create a new account variable with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/New-DattoRMMAccountVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'CreateData', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'Create')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter( Mandatory = $true, ParameterSetName = 'Create' )]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [Parameter( Mandatory = $false, ParameterSetName = 'Create' )]
        [switch]$Masked,

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

        $ResourceUri = "/account/variable"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Create') {

            $Data = [PSCustomObject]@{
                name    = $Name
                value   = $Value
                masked  = $Masked.IsPresent
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
