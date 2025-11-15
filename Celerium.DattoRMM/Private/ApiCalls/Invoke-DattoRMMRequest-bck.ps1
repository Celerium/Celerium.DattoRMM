function Invoke-DattoRMMRequest {
<#
    .SYNOPSIS
        Makes an API request to DattoRMM

    .DESCRIPTION
        The Invoke-DattoRMMRequest cmdlet invokes an API request to the DattoRMM API

        This is an internal function that is used by all public functions

    .PARAMETER Method
        Defines the type of API method to use

        Allowed values:
        'GET', 'POST', 'PATCH', 'DELETE'

    .PARAMETER ResourceURI
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER UriFilter
        Hashtable of values to combine a functions parameters with
        the ResourceUri parameter

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $DattoRMMModuleBaseUri + $ResourceURI + ConvertTo-DattoRMMQueryString

    .PARAMETER Data
        Object containing supported DattoRMM method schemas

        Commonly used when bulk adjusting DattoRMM data

    .PARAMETER AllResults
        Returns all items from an endpoint

    .EXAMPLE
        Invoke-DattoRMMRequest -Method GET -ResourceURI '/passwords' -UriFilter $UriFilter

        Invoke a rest method against the defined resource using the provided parameters

        Example HashTable:
            $UriParameters = @{
                'filter[id]']               = 123456789
                'filter[organization_id]']  = 12345
            }

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Invoke-DattoRMMRequest.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Invoke', SupportsShouldProcess)]
    param (
        [Parameter()]
        [ValidateSet('GET', 'POST', 'PATCH', 'DELETE')]
        [string]$Method = 'GET',

        [Parameter(Mandatory = $true)]
        [string]$ResourceURI,

        [Parameter()]
        [hashtable]$UriFilter,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $Data,

        [Parameter()]
        [switch]$AllResults
    )

    begin {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        try {

            $AllResponseData = [System.Collections.Generic.List[object]]::new()
            $Page       = 0
            $RetryCount = 0
            $RetryMax   = 3

            if($AllResults ) { if (-not $UriFilter) {$UriFilter = @{}} }

            if ($UriFilter) {
                if ($UriFilter.Keys -contains 'page') { $Page = $UriFilter['page'] }

                $QueryString = ConvertTo-DattoRMMQueryString -UriFilter $UriFilter
                Set-Variable -Name $QueryParameterName -Value $QueryString -Scope Global -Force -Confirm:$false
            }

            if ([bool]$DattoRMMModuleAccessToken.access_token -eq $false) { Request-DattoRMMAccessToken -ErrorAction Stop }
            $Headers = @{ 'Authorization' = "Bearer $($DattoRMMModuleAccessToken.access_token)" }

            switch ([bool]$Data) {
                $true   { $Body = @{'data'=$Data} | ConvertTo-Json -Depth $DattoRMMModuleJSONConversionDepth }
                $false  { $Body = $null }
            }

            $Parameters = @{
                'Method'    = $Method
                'Uri'       = $DattoRMMModuleBaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI + $QueryString
                'Headers'   = $Headers
                'UserAgent' = $DattoRMMModuleUserAgent
                'Body'      = $Body
            }

            if($Method -ne 'GET') {
                $Parameters['ContentType'] = 'application/json; charset=utf-8'
            }

            Set-Variable -Name $ParameterName -Value $Parameters -Scope Global -Force -Confirm:$false

            if ($AllResults) {
                do {

                    $ApiResponse = Invoke-RestMethod @Parameters -ErrorAction Stop

                    Write-Verbose "Processing [ $($ApiResponse.pageDetails.count) ] items from page [ $Page ]"

                    $DataObjectName = $ApiResponse.PSObject.Properties.Name | Where-Object {$_ -ne 'pageDetails'}

                    if (($DataObjectName | Measure-Object).Count -gt 1) {
                        Write-Warning "Multiple data objects found: [ $($DataObjectName -join ', ')]"
                    }

                    foreach ($Item in $ApiResponse.$DataObjectName) {
                        $AllResponseData.Add($Item) > $null
                    }

                    $Parameters.Remove('Uri') > $null
                    $Parameters.Add('Uri',$ApiResponse.pageDetails.nextPageUrl)

                    $Page++

                }
                while ( $null -ne $ApiResponse.pageDetails.nextPageUrl -or $RetryCount -lt $RetryMax)
            }
            else {

                $ApiResponse = Invoke-RestMethod @Parameters -ErrorAction Stop

                switch ( ($ApiResponse.PSObject.Properties.Name) -contains 'pageDetails' ) {
                    $true   {
                        Write-Verbose "Processing [ $($ApiResponse.pageDetails.count) ] items from page [ $Page ]"

                        $DataObjectName = $ApiResponse.PSObject.Properties.Name | Where-Object {$_ -ne 'pageDetails'}

                        if (($DataObjectName | Measure-Object).Count -gt 1) {
                            Write-Warning "Multiple data objects found: [ $($DataObjectName -join ', ')]"
                        }

                        foreach ($Item in $ApiResponse.$DataObjectName) {
                            $AllResponseData.Add($Item) > $null
                        }

                    }
                    $false  { $AllResponseData = $ApiResponse }
                }

            }

        }
        catch {

            $ExceptionError = $_.Exception.Message
            Write-Warning 'The [ Invoke_DattoRMMRequest_Parameters, Invoke_DattoRMMRequest_ParametersQuery, & CmdletName_Parameters ] variables can provide extra details'

            switch -Wildcard ($ExceptionError) {
                '*403*' { Write-Error "Invoke-DattoRMMRequest : AWS DDOS protection breached - Wait 5 minutes" }
                '*404*' { Write-Error "Invoke-DattoRMMRequest : URI not found - [ $ResourceURI ]" }
                '*429*' { Write-Error 'Invoke-DattoRMMRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-DattoRMMRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

            $RetryCount++
            if ($RetryCount -lt $RetryMax) {
                Write-Warning "Invoke-DattoRMMRequest : Retrying request [ $ResourceURI ] - Attempt [ $RetryCount/$RetryMax ]"
            }
            else{
                Write-Error "Invoke-DattoRMMRequest : Maximum retry attempts reached"
                break
            }

        }
        finally {

            $Auth = $Invoke_DattoRMMRequest_Parameters['headers']['Authorization']
            $Invoke_DattoRMMRequest_Parameters['headers']['Authorization'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 9) ) + '*******'

        }

        #Formatting return data to be consistent for all calls
        if( [string]::IsNullOrEmpty($AllResponseData) ) {
            $ApiResponse = $null
        }
        else{
            $ApiResponse = [PSCustomObject]@{
                pageDetails = [PSCustomObject]@{
                                'count'         = ($AllResponseData | Measure-Object).Count
                                'totalCount'    = $null
                                'prevPageUrl'   = $null
                                'nextPageUrl'   = $null
                            }
                data        = $AllResponseData
            }
        }

        return $ApiResponse

    }

    end {}

}
