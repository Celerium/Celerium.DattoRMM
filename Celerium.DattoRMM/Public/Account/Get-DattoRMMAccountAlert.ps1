function Get-DattoRMMAccountAlert {
<#
    .SYNOPSIS
        Fetches the account alerts

    .DESCRIPTION
        The Get-DattoRMMAccountAlert cmdlet fetches the account alerts

    .PARAMETER AlertType
        Return items of a defined type

        By default only open alerts are returned

        Allowed Values:
            All
            Resolved
            Open

    .PARAMETER Muted
        Return items that are muted

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountAlert

        Gets the first 250 open account alerts

    .EXAMPLE
        Get-DattoRMMAccountAlert -AlertType Resolved

        Gets the first 250 resolved account alerts

    .EXAMPLE
        Get-DattoRMMAccountAlert -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountAlert.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet('All','Resolved','Open')]
        [string]$AlertType = 'Open',

        [Parameter( Mandatory = $false )]
        [switch]$Muted,

        [Parameter( Mandatory = $false )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page,

        [Parameter( Mandatory = $false)]
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

        switch ($AlertType) {
            'All'       { $ResourceUri = @("/account/alerts/resolved", "/account/alerts/open") }
            'Resolved'  { $ResourceUri = "/account/alerts/resolved" }
            'Open'      { $ResourceUri = "/account/alerts/open" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)  { $UriParameters['page']    = $Page }
            if ($Max)   { $UriParameters['max']     = $Max }
            if ($Muted) { $UriParameters['muted']   = $Muted }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($AlertType -eq 'All') {

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
