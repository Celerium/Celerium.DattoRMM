function Get-DattoRMMJob {
<#
    .SYNOPSIS
        Fetches data of the job identified by the given job Uid

    .DESCRIPTION
        The Get-DattoRMMJob cmdlet fetches data of the job
        identified by the given job Uid

        JobUID is returned when creating jobs via other cmdlets

    .PARAMETER JobUID
        Fetches data of the job identified by the given job Uid

    .PARAMETER Component
        Fetches components of the job

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMJob

        Prompts for a job Uid and fetches data of the job

    .EXAMPLE
        Get-DattoRMMJob -JobUID '123456789'

        Fetches data for the specific job Id

    .EXAMPLE
        Get-DattoRMMAccountAlert -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJob.html

#>

    [CmdletBinding(DefaultParameterSetName = 'JobOnly')]
    Param (
        [Parameter( Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$JobUID,

        [Parameter( Mandatory = $false, ParameterSetName = 'JobComponent' )]
        [ValidateNotNullOrEmpty()]
        [switch]$Component,

        [Parameter( Mandatory = $false, ParameterSetName = 'JobComponent' )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page,

        [Parameter( Mandatory = $false, ParameterSetName = 'JobComponent' )]
        [ValidateRange(1, 250)]
        [int]$Max = 250,

        [Parameter( Mandatory = $false, ParameterSetName = 'JobComponent' )]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'JobOnly'       { $ResourceUri = "/job/$JobUID" }
            'JobComponent'  { $ResourceUri = "/job/$JobUID/components" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'JobComponent') {
            if ($Page)  { $UriParameters['page']    = $Page }
            if ($Max)   { $UriParameters['max']     = $Max }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
