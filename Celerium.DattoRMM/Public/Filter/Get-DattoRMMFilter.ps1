function Get-DattoRMMFilter {
<#
    .SYNOPSIS
        Gets both default & custom filters

    .DESCRIPTION
        The Get-DattoRMMFilter cmdlet gets both default & custom filters

    .PARAMETER FilterType
        Define the type of filter to return

        Allowed Values:
            All
            Default
            Custom

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMFilter

        Gets the first 250 default filters

    .EXAMPLE
        Get-DattoRMMFilter -FilterType All

        Gets the first 250 filters of all types

    .EXAMPLE
        Get-DattoRMMFilter -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Filter/Get-DattoRMMFilter.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet('All', 'Default', 'Custom')]
        [string]$FilterType = 'Default',

        [Parameter( Mandatory = $false )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page = 0,

        [Parameter( Mandatory = $false )]
        [ValidateRange(1, 250)]
        [int]$Max = 250,

        [Parameter( Mandatory = $false )]
        [switch]$AllResults
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($FilterType) {
            'All'       { $ResourceUri = @("/filter/default-filters", "/filter/custom-filters") }
            'Custom'    { $ResourceUri = "/filter/custom-filters" }
            'Default'   { $ResourceUri = "/filter/default-filters" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)  { $UriParameters['page']    = $Page }
            if ($Max)   { $UriParameters['max']     = $Max }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($FilterType -eq 'All') {

            $ReturnData = [System.Collections.Generic.List[object]]::new()
            foreach ($Uri in $ResourceUri) {

                $Data = Invoke-DattoRMMRequest -Method GET -ResourceURI $Uri -UriFilter $UriParameters -AllResults:$AllResults
                foreach ($Item in $data.data) {
                    $ReturnData.Add($Item) > $null
                }

            }

            return [PSCustomObject]@{
                pageDetails = [PSCustomObject]@{
                                'count'         = ($ReturnData | Measure-Object).Count
                                'totalCount'    = $null
                                'prevPageUrl'   = $null
                                'nextPageUrl'   = $null
                            }
                data        = $ReturnData
            }

        }
        else{
            return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults
        }

    }

    end {}

}
