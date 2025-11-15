function Get-DattoRMMDeviceAlert {
<#
    .SYNOPSIS
        Fetches the alerts of the device identified by the given device Uid

    .DESCRIPTION
        The Get-DattoRMMDeviceAlert cmdlet fetches the alerts of the device
        identified by the given device Uid

    .PARAMETER AlertType
        Fetches data of the specific alert type

        Allowed values:
            'All'
            'Resolved'
            'Open'

    .PARAMETER DeviceUID
        Fetches data of the alert identified by the given device Id

    .PARAMETER Muted
        Fetches data of muted alerts

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMDeviceAlert

        Prompts for a device Uid and fetches data of the device

    .EXAMPLE
        Get-DattoRMMDeviceAlert -DeviceUID '123456789'

        Fetches data for the specific device Uid

    .EXAMPLE
        Get-DattoRMMDeviceAlert -MacAddress '00155DC07E1F'

        Fetches data for the specific device mac address

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDeviceAlert.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet('All','Resolved','Open')]
        [string]$AlertType = 'Open',

        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $false )]
        [ValidateNotNullOrEmpty()]
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
            'All'       { $ResourceUri = @("/device/$DeviceUID/alerts/resolved","/device/$DeviceUID/alerts/open") }
            'Resolved'  { $ResourceUri = "/device/$DeviceUID/alerts/resolved" }
            'Open'      { $ResourceUri = "/device/$DeviceUID/alerts/open" }
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
