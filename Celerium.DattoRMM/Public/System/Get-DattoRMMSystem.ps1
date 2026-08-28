function Get-DattoRMMSystem {
<#
    .SYNOPSIS
        Gets various DattoRMM system operation information

    .DESCRIPTION
        The Get-DattoRMMSystem cmdlet gets various DattoRMM
        system operation information

    .PARAMETER Status
        Gets the system status (start date, status and version)

    .PARAMETER RequestRate
        Gets the request rate status for the authenticated user's account

    .PARAMETER Pagination
        Gets the pagination configurations

    .EXAMPLE
        Get-DattoRMMSystem

        Gets the system status (start date, status and version)

    .EXAMPLE
        Get-DattoRMMSystem -RequestRate

        Gets the request rate status for the authenticated user's account

    .EXAMPLE
        Get-DattoRMMSystem -Pagination

        Gets the pagination configurations

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/System/Get-DattoRMMSystem.html

    .LINK
        https://zinfandel-api.centrastage.net/api/swagger-ui/index.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Status')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Status')]
        [switch]$Status,

        [Parameter(Mandatory = $false, ParameterSetName = 'RequestRate')]
        [switch]$RequestRate,

        [Parameter(Mandatory = $false, ParameterSetName = 'Pagination')]
        [switch]$Pagination
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Status'        { $ResourceUri = "/system/status"        }
            'RequestRate'   { $ResourceUri = "/system/request_rate"  }
            'Pagination'    { $ResourceUri = "/system/pagination"    }
        }

        #$UriParameters = @{}

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri #-UriFilter $UriParameters

    }

    end {}

}
