#Region '.\Private\ApiCalls\ConvertTo-DattoRMMQueryString.ps1' -1

function ConvertTo-DattoRMMQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The ConvertTo-DattoRMMQueryString cmdlet converts & formats uri query parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        ConvertTo-DattoRMMQueryString & any public functions that define parameters

    .PARAMETER UriFilter
        Hashtable of values to combine a functions parameters with
        the ResourceUri parameter

        This allows for the full uri query to occur

    .EXAMPLE
        ConvertTo-DattoRMMQueryString -UriFilter $HashTable

        Example HashTable:
            $UriParameters = @{
                'filter[id]']               = 123456789
                'filter[organization_id]']  = 12345
            }

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/ConvertTo-DattoRMMQueryString.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Convert')]
    Param (
        [Parameter(Mandatory = $false)]
        [hashtable]$UriFilter
    )

    begin {}

    process{

        if (-not $UriFilter) {
            return ""
        }

        $params = @()
        foreach ($key in $UriFilter.Keys) {
            $value = [System.Net.WebUtility]::UrlEncode($UriFilter[$key])
            $params += "$key=$value"
        }

        $QueryString = '?' + ($params -join '&')
        return $QueryString

    }

    end{}

}
#EndRegion '.\Private\ApiCalls\ConvertTo-DattoRMMQueryString.ps1' 64
#Region '.\Private\ApiCalls\Invoke-DattoRMMRequest.ps1' -1

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
        [ValidateSet('GET', 'PUT', 'POST', 'PATCH', 'DELETE')]
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
            $RetryCount = 1
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
                $true   {

                    $DataToJson         = $Data | ConvertTo-Json -Depth $DattoRMMModuleJSONConversionDepth
                    [byte[]]$DataToUtf8 = [System.Text.Encoding]::UTF8.GetBytes($DataToJson)

                    $Body = $DataToUtf8
                }
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

                    try {

                        $ApiResponse = Invoke-RestMethod @Parameters

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
                    catch {

                        $ExceptionError = $_.Exception.Message
                        Write-Warning 'The [ Invoke_DattoRMMRequest_Parameters, Invoke_DattoRMMRequest_ParametersQuery, & CmdletName_Parameters ] variables can provide extra details'

                        $RandomWaitTime = Get-Random -Minimum 60 -Maximum 300

                        switch -Wildcard ($ExceptionError) {
                            '*400*' {   Write-Error $_ -ErrorVariable SkipLoopError}
                            '*403*' {   Write-Error "Invoke-DattoRMMRequest : AWS DDOS protection breached - Sleeping for 300 seconds"
                                        Start-Sleep -Seconds 300
                                    }
                            '*404*' {   Write-Error "Invoke-DattoRMMRequest : URI not found - [ $ResourceURI ]" -ErrorVariable SkipLoopError}
                            '*429*' {   Write-Error "Invoke-DattoRMMRequest : API rate limited  - Sleeping for $RandomWaitTime seconds"
                                        Start-Sleep -Seconds $RandomWaitTime
                                    }
                            '*504*' {   Write-Error "Invoke-DattoRMMRequest : Gateway Timeout  - Sleeping for $RandomWaitTime seconds"
                                        Start-Sleep -Seconds $RandomWaitTime
                                    }
                            default { Write-Error $_ }
                        }

                        $RetryCount++
                        if ([bool]$SkipLoopError){$null}
                        elseif ($RetryCount -lt $RetryMax) {
                            Write-Warning "Invoke-DattoRMMRequest : Retrying request [ $ResourceURI ] - Attempt [ $RetryCount/$RetryMax ]"
                        }
                        else{
                            Write-Error "Invoke-DattoRMMRequest : Maximum retry attempts reached [ $RetryCount/$RetryMax ]"
                            break
                        }

                    }

                }
                while ($null -ne $ApiResponse.pageDetails.nextPageUrl -and $RetryCount -lt $RetryMax -and [bool]$SkipLoopError -eq $false)
            }
            else {

                do {

                    try {

                        $ApiResponse = Invoke-RestMethod @Parameters

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
                    catch {

                        $ExceptionError = $_.Exception.Message
                        Write-Warning 'The [ Invoke_DattoRMMRequest_Parameters, Invoke_DattoRMMRequest_ParametersQuery, & CmdletName_Parameters ] variables can provide extra details'

                        $RandomWaitTime = Get-Random -Minimum 60 -Maximum 300

                        switch -Wildcard ($ExceptionError) {
                            '*400*' {   Write-Error $_ -ErrorVariable SkipLoopError}
                            '*403*' {   Write-Error "Invoke-DattoRMMRequest : AWS DDOS protection breached - Sleeping for 300 seconds"
                                        Start-Sleep -Seconds 300
                                    }
                            '*404*' {   Write-Error "Invoke-DattoRMMRequest : URI not found - [ $ResourceURI ]" -ErrorVariable UriNotFoundError}
                            '*429*' {   Write-Error "Invoke-DattoRMMRequest : API rate limited  - Sleeping for $RandomWaitTime seconds"
                                        Start-Sleep -Seconds $RandomWaitTime
                                    }
                            '*504*' {   Write-Error "Invoke-DattoRMMRequest : Gateway Timeout  - Sleeping for $RandomWaitTime seconds"
                                        Start-Sleep -Seconds $RandomWaitTime
                                    }
                            default { Write-Error $_ }
                        }

                        $RetryCount++
                        if ([bool]$SkipLoopError){$null}
                        elseif ($RetryCount -lt $RetryMax) {
                            Write-Warning "Invoke-DattoRMMRequest : Retrying request [ $ResourceURI ] - Attempt [ $RetryCount/$RetryMax ]"
                        }
                        else{
                            Write-Error "Invoke-DattoRMMRequest : Maximum retry attempts reached [ $RetryCount/$RetryMax ]"
                            break
                        }

                    }

                }
                while ($RetryMax -lt $RetryCount -and [bool]$SkipLoopError -eq $false)

            }

        }
        catch {
            Write-Error $_
            exit 1
        }
        finally {
            $Auth = $Invoke_DattoRMMRequest_Parameters['headers']['Authorization']
            $Invoke_DattoRMMRequest_Parameters['headers']['Authorization'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 9) ) + '*******'
        }

        #Formatting return data to be consistent for all calls
        #[String]::IsNullOrEmpty($AllResponseData) -eq $true
        if( ($AllResponseData | Measure-Object).Count -eq 0 -or $AllResponseData.Length -eq 0) { $ApiResponse = $null }
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
#EndRegion '.\Private\ApiCalls\Invoke-DattoRMMRequest.ps1' 296
#Region '.\Private\ApiCalls\Invoke-DattoRMMRequest-bck.ps1' -1

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
#EndRegion '.\Private\ApiCalls\Invoke-DattoRMMRequest-bck.ps1' 233
#Region '.\Private\ApiKeys\Add-DattoRMMAPIKey.ps1' -1

function Add-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls

    .DESCRIPTION
        The Add-DattoRMMAPIKey cmdlet sets your API key which is used to
        authenticate all API calls made to DattoRMM

        DattoRMM API keys can be generated via the DattoRMM web interface
            Setup > Users > {user} > API

    .PARAMETER ApiKey
        Plain text API key

    .PARAMETER ApiSecretKey
        Plain text API secret key

        If not defined the cmdlet will prompt you to enter the API secret key which
        will be stored as a SecureString

    .PARAMETER ApiKeySecureString
        Input a SecureString object containing the API key

    .EXAMPLE
        Add-DattoRMMAPIKey -ApiKey '12345'

        Prompts to enter in the API secret key which will be stored as a SecureString

    .EXAMPLE
        Add-DattoRMMAPIKey -ApiKey '12345' -ApiSecretKey '12345'

        Converts the string to a SecureString and stores it in the global variable

    .EXAMPLE
        'Celerium@Celerium.org' | Add-DattoRMMAPIKey -ApiKey '12345'

        Converts the string to a SecureString and stores it in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'AsPlainText')]
    [Alias('Set-DattoRMMAPIKey')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'AsPlainText')]
        [AllowEmptyString()]
        [string]$ApiSecretKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ParameterSetName = 'SecureString')]
        [ValidateNotNullOrEmpty()]
        [securestring]$ApiKeySecureString
    )

    begin {}

    process{

        switch ($PSCmdlet.ParameterSetName) {

            'AsPlainText' {

                if ($ApiSecretKey) {
                    $SecureString = ConvertTo-SecureString $ApiSecretKey -AsPlainText -Force

                    Set-Variable -Name "DattoRMMModuleApiKey"       -Value $ApiKey -Option ReadOnly -Scope Global -Force
                    Set-Variable -Name "DattoRMMModuleApiSecretKey" -Value $SecureString -Option ReadOnly -Scope Global -Force
                }
                else {
                    Write-Output "Please enter your API key:"
                    $SecureString = Read-Host -AsSecureString

                    Set-Variable -Name "DattoRMMModuleApiKey"       -Value $ApiKey -Option ReadOnly -Scope Global -Force
                    Set-Variable -Name "DattoRMMModuleApiSecretKey" -Value $SecureString -Option ReadOnly -Scope Global -Force
                }

            }

            'SecureString' {

                Set-Variable -Name "DattoRMMModuleApiKey"       -Value $ApiKey -Option ReadOnly -Scope Global -Force
                Set-Variable -Name "DattoRMMModuleApiSecretKey" -Value $ApiKeySecureString -Option ReadOnly -Scope Global -Force

            }

        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Add-DattoRMMAPIKey.ps1' 101
#Region '.\Private\ApiKeys\Get-DattoRMMAccessToken.ps1' -1

function Get-DattoRMMAccessToken {
<#
    .SYNOPSIS
        Gets the stored JWT access token

    .DESCRIPTION
        The Get-DattoRMMAccessToken cmdlet gets the stored JWT access token

    .EXAMPLE
        Get-DattoRMMAccessToken

        Gets the stored JWT access token

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMAccessToken.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {}

    process{

        switch ([bool]$DattoRMMModuleAccessToken.access_token) {
            $true   { $DattoRMMModuleAccessToken }
            $false  { Write-Warning "The DattoRMM access token is not set. Run Request-DattoRMMAccessToken to set the access token" }
        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Get-DattoRMMAccessToken.ps1' 38
#Region '.\Private\ApiKeys\Get-DattoRMMAPIKey.ps1' -1

function Get-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Gets the DattoRMM API key

    .DESCRIPTION
        The Get-DattoRMMAPIKey cmdlet gets the DattoRMM API key from
        the global variable and returns it as an object

    .PARAMETER AsPlainText
        Decrypt and return the API key in plain text

    .EXAMPLE
        Get-DattoRMMAPIKey

        Gets the Api & Api secret key and returns them as an object. The
        API secret key is returned as a secure string

    .EXAMPLE
        Get-DattoRMMAPIKey -AsPlainText

        Gets the Api & Api secret key and returns them as an object. The
        API secret key is returned as plain text

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(Mandatory = $false)]
        [switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($DattoRMMModuleApiSecretKey) {

                if ($AsPlainText) {
                    $ApiSecretKey = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DattoRMMModuleApiSecretKey)

                    [PSCustomObject]@{
                        ApiKey          = $DattoRMMModuleApiKey
                        ApiSecretKey    = ( [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ApiSecretKey) ).ToString()
                    }
                }
                else {
                    [PSCustomObject]@{
                        ApiKey          = $DattoRMMModuleApiKey
                        ApiSecretKey    = $DattoRMMModuleApiSecretKey
                    }
                }

            }
            else { Write-Warning "The DattoRMM API secret key is not set. Run Add-DattoRMMAPIKey to set the API key" }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($ApiSecretKey) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiSecretKey)
            }
        }


    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Get-DattoRMMAPIKey.ps1' 80
#Region '.\Private\ApiKeys\Remove-DattoRMMAPIKey.ps1' -1

function Remove-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Removes the Api & Api secret keys from the global variables

    .DESCRIPTION
        The Remove-DattoRMMAPIKey cmdlet removes the Api & Api secret keys
        from the global variables

    .EXAMPLE
        Remove-DattoRMMAPIKey

        Removes the Api & Api secret keys from the global variables

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$DattoRMMModuleApiKey) {
            $true   { Remove-Variable -Name "DattoRMMModuleApiKey" -Scope Global -Force }
            $false  { Write-Warning "The Datto API key is not set. Nothing to remove" }
        }

        switch ([bool]$DattoRMMModuleApiSecretKey) {
            $true   { Remove-Variable -Name "DattoRMMModuleApiSecretKey" -Scope Global -Force }
            $false  { Write-Warning "The Datto API secret key is not set. Nothing to remove" }
        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Remove-DattoRMMAPIKey.ps1' 44
#Region '.\Private\ApiKeys\Request-DattoRMMAccessToken.ps1' -1

function Request-DattoRMMAccessToken {
<#
    .SYNOPSIS
        Requests an JWT access token using the users Api keys

    .DESCRIPTION
        The Request-DattoRMMAccessToken cmdlet requests an JWT access token using
        the users Api keys. The JWT token is used to validate all API calls made to DattoRMM

    .PARAMETER ApiUri
        Base URI for the DattoRMM Api connection

    .PARAMETER ApiKey
        Plain text API key

    .PARAMETER ApiSecretKey
        Plain text API secret key

        If not defined the cmdlet will prompt you to enter the API secret key which
        will be stored as a SecureString

    .PARAMETER ApiKeySecureString
        Input a SecureString object containing the API key

    .EXAMPLE
        Request-DattoRMMAccessToken

        Uses all the defined global variables to request an access token

    .EXAMPLE
        Request-DattoRMMAccessToken -ApiUri 'https://gateway.celerium.org' -ApiKey '12345' -ApiSecretKey '12345'

        Using the define values, sets, converts, & adds the values to global variables and requests an access token

    .EXAMPLE
        'Celerium@Celerium.org' | Request-DattoRMMAccessToken -ApiKey '12345' -ApiSecretKey '12345'

        Using the define values, sets, converts, & adds the values to global variables and requests an access token

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Request-DattoRMMAccessToken.html
#>

    [CmdletBinding(DefaultParameterSetName = 'RequestToken')]
    [Alias('Set-DattoRMMAccessToken')]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiUri = $DattoRMMModuleBaseUri,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey = $DattoRMMModuleApiKey,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiSecretKey = $(Get-DattoRMMAPIKey -AsPlainText).ApiSecretKey

    )

    begin {}

    process{

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]'Tls12'

        $ClientID       = 'public-client'
        $ClientSecret   = ConvertTo-SecureString -String 'public' -AsPlainText -Force

        $InvokeParams = @{
            Credential  = New-Object System.Management.Automation.PSCredential -ArgumentList ($ClientID, $ClientSecret)
            Uri         = "$ApiUri/auth/oauth/token"
            Method      = 'POST'
            ContentType = 'application/x-www-form-urlencoded'
            Body        = "grant_type=password&username=$ApiKey&password=$ApiSecretKey"
        }

        try {
            $AccessTokenResponse = Invoke-RestMethod @InvokeParams

            if ($AccessTokenResponse) {
                Set-Variable -Name "DattoRMMModuleAccessToken" -Value $AccessTokenResponse -Option ReadOnly -Scope Global -Force
            }

        }
        catch {
            Write-Error $_
            exit 1
        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Request-DattoRMMAccessToken.ps1' 99
#Region '.\Private\ApiKeys\Test-DattoRMMAPIKey.ps1' -1

function Test-DattoRMMAPIKey {
<#
    .SYNOPSIS
        Test the DattoRMM API key

    .DESCRIPTION
        The Test-DattoRMMAPIKey cmdlet tests the base URI & API key that are defined
        in the Add-DattoRMMBaseURI & Add-DattoRMMAPIKey cmdlets

        Helpful when needing to validate general functionality or when using
        RMM deployment tools

        The DattoRMM status endpoint is called in this test

    .PARAMETER BaseUri
        Define the base URI for the DattoRMM API connection
        using DattoRMM's URI or a custom URI

        By default the value used is the one defined by the
        Add-DattoRMMBaseURI function

    .EXAMPLE
        Test-DattoRMMAPIKey

        Tests the base URI & API key that are defined in the
        Add-DattoRMMBaseURI & Add-DattoRMMAPIKey cmdlets

    .EXAMPLE
        Test-DattoRMMAPIKey -BaseUri http://myapi.gateway.celerium.org

        Tests the defined base URI & API key that was defined in
        the Add-DattoRMMAPIKey cmdlet

        The full base uri test path in this example is:
            http://myapi.gateway.celerium.org/regions

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Test-DattoRMMAPIKey.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Test')]
    Param (
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUri = $DattoRMMModuleBaseUri
    )

    begin { $ResourceUri = "/system/status" }

    process {

        Write-Verbose "Testing API key against [ $($BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI) ]"

        try {

            if ([bool]$DattoRMMModuleAccessToken.access_token -eq $false) { Request-DattoRMMAccessToken -ErrorAction Stop }
            $Headers = @{ 'Authorization' = "Bearer $($DattoRMMModuleAccessToken.access_token)" }

            $Parameters = @{
                'Method'    = 'GET'
                'Uri'       = $BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI
                'Headers'   = $Headers
                'UserAgent' = $DattoRMMModuleUserAgent
            }

            $rest_output = Invoke-WebRequest @Parameters -ErrorAction Stop

        }
        catch {

            [PSCustomObject]@{
                Method              = $_.Exception.Response.Method
                StatusCode          = $_.Exception.Response.StatusCode.value__
                StatusDescription   = $_.Exception.Response.StatusDescription
                Message             = $_.Exception.Message
                URI                 = $($BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI)
            }

        } finally {
            [void] ($Headers.Remove('Authorization'))
        }

        if ($rest_output) {
            $Data = @{}
            $Data = $rest_output

            [PSCustomObject]@{
                StatusCode          = $Data.StatusCode
                StatusDescription   = $Data.StatusDescription
                URI                 = $($BaseUri + $DattoRMMModuleBaseApiUri + $ResourceURI)
            }
        }

    }

    end {}

}
#EndRegion '.\Private\ApiKeys\Test-DattoRMMAPIKey.ps1' 102
#Region '.\Private\BaseUri\Add-DattoRMMBaseURI.ps1' -1

function Add-DattoRMMBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the DattoRMM API connection

    .DESCRIPTION
        The Add-DattoRMMBaseURI cmdlet sets the base URI which is used
        to construct the full URI for all API calls

    .PARAMETER BaseUri
        Sets the base URI for the DattoRMM API connection. Helpful
        if using a custom API gateway

    .PARAMETER BaseApiUri
        Sets the base Api URI for the DattoRMM API connection

    .PARAMETER DataCenter
        Defines the data center (platform) to use which in turn defines which
        base API URL is used

        Allowed values:
        'Pinotage', 'Merlot', 'Concord', 'Vidal', 'Zinfandel', 'Syrah'

            'Pinotage'  = 'https://pinotage-api.centrastage.net'
            'Merlot'    = 'https://merlot-api.centrastage.net'
            'Concord'   = 'https://concord-api.centrastage.net'
            'Vidal'     = 'https://vidal-api.centrastage.net'
            'Zinfandel' = 'https://zinfandel-api.centrastage.net'
            'Syrah'     = 'https://syrah-api.centrastage.net'

    .EXAMPLE
        Add-DattoRMMBaseURI

        You will be prompted to select a data center

    .EXAMPLE
        Add-DattoRMMBaseURI -BaseUri 'https://gateway.celerium.org'

        The base URI will use https://gateway.celerium.org

    .EXAMPLE
        'https://gateway.celerium.org' | Add-DattoRMMBaseURI

        The base URI will use https://gateway.celerium.org

    .EXAMPLE
        Add-DattoRMMBaseURI -DataCenter Pinotage

        The base URI will use https://pinotage-api.centrastage.net

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMBaseURI.html
#>

    [CmdletBinding(DefaultParameterSetName = 'PreDefinedUri')]
    [Alias('Set-DattoRMMBaseURI')]
    Param (
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'CustomUri')]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUri,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseApiUri = '/api/v2',

        [parameter(Mandatory = $true, ParameterSetName = 'PreDefinedUri')]
        [ValidateSet( 'Pinotage', 'Merlot', 'Concord', 'Vidal', 'Zinfandel', 'Syrah')]
        [Alias('Platform')]
        [string]$DataCenter
    )

    begin {}

    process{

        if($BaseUri[$BaseUri.Length-1] -eq "/") {
            $BaseUri = $BaseUri.Substring(0,$BaseUri.Length-1)
        }

        switch ($DataCenter) {
            'Pinotage'  { $BaseUri = 'https://pinotage-api.centrastage.net'  }
            'Merlot'    { $BaseUri = 'https://merlot-api.centrastage.net'    }
            'Concord'   { $BaseUri = 'https://concord-api.centrastage.net'   }
            'Vidal'     { $BaseUri = 'https://vidal-api.centrastage.net'     }
            'Zinfandel' { $BaseUri = 'https://zinfandel-api.centrastage.net' }
            'Syrah'     { $BaseUri = 'https://syrah-api.centrastage.net'     }
            Default {}
        }

        Set-Variable -Name "DattoRMMModuleBaseUri" -Value $BaseUri -Option ReadOnly -Scope Global -Force
        Set-Variable -Name "DattoRMMModuleBaseApiUri" -Value $BaseApiUri -Option ReadOnly -Scope Global -Force

    }

    end {}

}
#EndRegion '.\Private\BaseUri\Add-DattoRMMBaseURI.ps1' 101
#Region '.\Private\BaseUri\Get-DattoRMMBaseURI.ps1' -1

function Get-DattoRMMBaseURI {
<#
    .SYNOPSIS
        Shows the DattoRMM base URI

    .DESCRIPTION
        The Get-DattoRMMBaseURI cmdlet shows the DattoRMM base URI from
        the global variable

    .PARAMETER AndApiUri
        Also include the default Api version uri

    .EXAMPLE
        Get-DattoRMMBaseURI

        Shows the DattoRMM base URI value defined in the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMBaseURI.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter(Mandatory = $false)]
        [switch]$AndApiUri
    )

    begin {}

    process {

        switch ([bool]$DattoRMMModuleBaseUri) {
            $true   {
                if ($AndApiUri) { $DattoRMMModuleBaseUri + $DattoRMMModuleBaseApiUri }
                else { $DattoRMMModuleBaseUri }
            }
            $false  { Write-Warning "The DattoRMM base URI is not set. Run Add-DattoRMMBaseURI to set the base URI." }
        }

    }

    end {}

}
#EndRegion '.\Private\BaseUri\Get-DattoRMMBaseURI.ps1' 48
#Region '.\Private\BaseUri\Remove-DattoRMMBaseURI.ps1' -1

function Remove-DattoRMMBaseURI {
<#
    .SYNOPSIS
        Removes the DattoRMM base URI global variable

    .DESCRIPTION
        The Remove-DattoRMMBaseURI cmdlet removes the DattoRMM base URI from
        the global variable

    .EXAMPLE
        Remove-DattoRMMBaseURI

        Removes the DattoRMM base URI value from the global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMBaseURI.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param ()

    begin {}

    process {

        switch ([bool]$DattoRMMModuleBaseUri) {

            $true   {
                if ($PSCmdlet.ShouldProcess('DattoRMMModuleBaseUri')) {
                    Remove-Variable -Name "DattoRMMModuleBaseUri" -Scope Global -Force
                    Remove-Variable -Name "DattoRMMModuleBaseApiUri" -Scope Global -Force
                }
            }
            $false  { Write-Warning "The DattoRMM base URI variable is not set. Nothing to remove" }

        }

    }

    end {}

}
#EndRegion '.\Private\BaseUri\Remove-DattoRMMBaseURI.ps1' 46
#Region '.\Private\ModuleSettings\Export-DattoRMMModuleSettings.ps1' -1

function Export-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Exports the DattoRMM BaseURI, API, & JSON configuration information to file

    .DESCRIPTION
        The Export-DattoRMMModuleSettings cmdlet exports the DattoRMM BaseURI, API, & JSON configuration information to file

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
        This means that you cannot copy your configuration file to another computer or user account and expect it to work

    .PARAMETER DattoRMMConfigPath
        Define the location to store the DattoRMM configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigFile
        Define the name of the DattoRMM configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-DattoRMMModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's DattoRMM configuration file located at:
            $env:USERPROFILE\Celerium.DattoRMM\config.psd1

    .EXAMPLE
        Export-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's DattoRMM configuration file located at:
            C:\Celerium.DattoRMM\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Export-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [string]$DattoRMMConfigFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $DattoRMMConfig = Join-Path -Path $DattoRMMConfigPath -ChildPath $DattoRMMConfigFile

        $GlobalModuleVariables = @('DattoRMMModuleBaseUri', 'DattoRMMModuleBaseApiUri', 'DattoRMMModuleApiKey', 'DattoRMMModuleApiSecretKey', 'DattoRMMModuleUserAgent', 'DattoRMMModuleJSONConversionDepth')
        foreach ($GlobalVariable in  $GlobalModuleVariables) {
            if (-not (Get-Variable -Name $GlobalVariable -ErrorAction SilentlyContinue -ErrorVariable GlobalVariableCheck)){
                Write-Error "The required module variable [ $GlobalVariable ] is not set"
            }
        }

        # Confirm variables exist and are not null before exporting
        if (-not $GlobalVariableCheck) {
            $SecureString = $DattoRMMModuleApiSecretKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $DattoRMMConfigPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $DattoRMMConfigPath -ItemType Directory -Force
            }
@"
    @{
        DattoRMMModuleBaseUri             = '$DattoRMMModuleBaseUri'
        DattoRMMModuleBaseApiUri          = '$DattoRMMModuleBaseApiUri'
        DattoRMMModuleApiKey              = '$DattoRMMModuleApiKey'
        DattoRMMModuleApiSecretKey        = '$SecureString'
        DattoRMMModuleUserAgent           = '$DattoRMMModuleUserAgent'
        DattoRMMModuleJSONConversionDepth = '$DattoRMMModuleJSONConversionDepth'
    }
"@ | Out-File -FilePath $DattoRMMConfig -Force
        }
        else {
            Write-Error "Failed to export DattoRMM Module settings to [ $DattoRMMConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Export-DattoRMMModuleSettings.ps1' 103
#Region '.\Private\ModuleSettings\Get-DattoRMMModuleSettings.ps1' -1

function Get-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Gets the saved DattoRMM configuration settings

    .DESCRIPTION
        The Get-DattoRMMModuleSettings cmdlet gets the saved DattoRMM configuration settings
        from the local system

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigPath
        Define the location to store the DattoRMM configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigFile
        Define the name of the DattoRMM configuration file

        By default the configuration file is named:
            config.psd1

    .PARAMETER OpenConfigFile
        Opens the DattoRMM configuration file

    .EXAMPLE
        Get-DattoRMMModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-DattoRMMModuleSettings

        The default location of the DattoRMM configuration file is:
            $env:USERPROFILE\Celerium.DattoRMM\config.psd1

    .EXAMPLE
        Get-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the DattoRMM configuration file in this example is:
            C:\Celerium.DattoRMM\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [string]$DattoRMMConfigFile = 'config.psd1',

        [Parameter()]
        [switch]$OpenConfigFile
    )

    begin {
        $DattoRMMConfig = Join-Path -Path $DattoRMMConfigPath -ChildPath $DattoRMMConfigFile
    }

    process {

        if (Test-Path -Path $DattoRMMConfig) {

            if($OpenConfigFile) {
                Invoke-Item -Path $DattoRMMConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $DattoRMMConfigPath -FileName $DattoRMMConfigFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $DattoRMMConfig ]"
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Get-DattoRMMModuleSettings.ps1' 89
#Region '.\Private\ModuleSettings\Import-DattoRMMModuleSettings.ps1' -1

function Import-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Imports the DattoRMM BaseURI, API, & JSON configuration information to the current session

    .DESCRIPTION
        The Import-DattoRMMModuleSettings cmdlet imports the DattoRMM BaseURI, API, & JSON configuration
        information stored in the DattoRMM configuration file to the users current session

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigPath
        Define the location to store the DattoRMM configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigFile
        Define the name of the DattoRMM configuration file

        By default the configuration file is named:
            config.psd1

    .PARAMETER SkipRequestToken
        Skips requesting an access token

    .EXAMPLE
        Import-DattoRMMModuleSettings

        Validates that the configuration file created with the Export-DattoRMMModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The default location of the DattoRMM configuration file is:
            $env:USERPROFILE\Celerium.DattoRMM\config.psd1

    .EXAMPLE
        Import-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1

        Validates that the configuration file created with the Export-DattoRMMModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The location of the DattoRMM configuration file in this example is:
            C:\Celerium.DattoRMM\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Import-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [string]$DattoRMMConfigFile = 'config.psd1',

        [Parameter()]
        [switch]$SkipRequestToken

    )

    begin {
        $DattoRMMConfig = Join-Path -Path $DattoRMMConfigPath -ChildPath $DattoRMMConfigFile

        $ModuleVersion = $MyInvocation.MyCommand.Version.ToString()

        switch ($PSVersionTable.PSEdition){
            'Core'      { $UserAgent = "Celerium.DattoRMM/$ModuleVersion - PowerShell/$($PSVersionTable.PSVersion) ($($PSVersionTable.Platform) $($PSVersionTable.OS))" }
            'Desktop'   { $UserAgent = "Celerium.DattoRMM/$ModuleVersion - WindowsPowerShell/$($PSVersionTable.PSVersion) ($($PSVersionTable.BuildVersion))" }
            default     { $UserAgent = "Celerium.DattoRMM/$ModuleVersion - $([Microsoft.PowerShell.Commands.PSUserAgent].GetMembers('Static, NonPublic').Where{$_.Name -eq 'UserAgent'}.GetValue($null,$null))" }
        }

    }

    process {

        if (Test-Path $DattoRMMConfig) {
            $TempConfig = Import-LocalizedData -BaseDirectory $DattoRMMConfigPath -FileName $DattoRMMConfigFile

            $TempConfig.DattoRMMModuleApiSecretKey = ConvertTo-SecureString $TempConfig.DattoRMMModuleApiSecretKey

            Set-Variable -Name "DattoRMMModuleBaseUri"              -Value $TempConfig.DattoRMMModuleBaseUri                -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleBaseApiUri"           -Value $TempConfig.DattoRMMModuleBaseApiUri             -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleApiKey"               -Value $TempConfig.DattoRMMModuleApiKey                 -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleApiSecretKey"         -Value $TempConfig.DattoRMMModuleApiSecretKey           -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleUserAgent"            -Value $TempConfig.DattoRMMModuleUserAgent              -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleJSONConversionDepth"  -Value $TempConfig.DattoRMMModuleJSONConversionDepth    -Option ReadOnly -Scope Global -Force

            if ($SkipRequestToken -eq $false){ Request-DattoRMMAccessToken }

            Write-Verbose "Celerium.DattoRMM Module configuration loaded successfully from [ $DattoRMMConfig ]"

            # Clean things up
            Remove-Variable "TempConfig"
        }
        else {
            Write-Verbose "No configuration file found at [ $DattoRMMConfig ] run Add-DattoRMMAPIKey, Add-DattoRMMBaseUri, & Request-DattoRMMAccessToken to get started"

            Set-Variable -Name "DattoRMMModuleUserAgent" -Value $UserAgent -Scope Global -Force
            Set-Variable -Name "DattoRMMModuleJSONConversionDepth" -Value 100 -Scope Global -Force
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Import-DattoRMMModuleSettings.ps1' 112
#Region '.\Private\ModuleSettings\Initialize-DattoRMMModuleSettings.ps1' -1

#Used to auto load either baseline settings or saved configurations when the module is imported
Import-DattoRMMModuleSettings -Verbose:$false
#EndRegion '.\Private\ModuleSettings\Initialize-DattoRMMModuleSettings.ps1' 3
#Region '.\Private\ModuleSettings\Remove-DattoRMMModuleSettings.ps1' -1

function Remove-DattoRMMModuleSettings {
<#
    .SYNOPSIS
        Removes the stored DattoRMM configuration folder

    .DESCRIPTION
        The Remove-DattoRMMModuleSettings cmdlet removes the DattoRMM folder and its files
        This cmdlet also has the option to remove sensitive DattoRMM variables as well

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER DattoRMMConfigPath
        Define the location of the DattoRMM configuration folder

        By default the configuration folder is located at:
            $env:USERPROFILE\Celerium.DattoRMM

    .PARAMETER AndVariables
        Define if sensitive DattoRMM variables should be removed as well

        By default the variables are not removed

    .EXAMPLE
        Remove-DattoRMMModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does

        The default location of the DattoRMM configuration folder is:
            $env:USERPROFILE\Celerium.DattoRMM

    .EXAMPLE
        Remove-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does
        If sensitive DattoRMM variables exist then they are removed as well

        The location of the DattoRMM configuration folder in this example is:
            C:\Celerium.DattoRMM

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'Destroy',SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter()]
        [string]$DattoRMMConfigPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) ),

        [Parameter()]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $DattoRMMConfigPath)  {

            Remove-Item -Path $DattoRMMConfigPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-DattoRMMApiKey
                Remove-DattoRMMBaseUri
            }

            if ($WhatIfPreference -eq $false) {

                if (!(Test-Path $DattoRMMConfigPath)) {
                    Write-Output "The Celerium.DattoRMM configuration folder has been removed successfully from [ $DattoRMMConfigPath ]"
                }
                else {
                    Write-Error "The Celerium.DattoRMM configuration folder could not be removed from [ $DattoRMMConfigPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $DattoRMMConfigPath ]"
        }

    }

    end {}

}
#EndRegion '.\Private\ModuleSettings\Remove-DattoRMMModuleSettings.ps1' 91
#Region '.\Public\Account\Get-DattoRMMAccount.ps1' -1

function Get-DattoRMMAccount {
<#
    .SYNOPSIS
        Fetches the authenticated user's account data.

    .DESCRIPTION
        The Get-DattoRMMAccount cmdlet fetches the authenticated
        user's account data

    .EXAMPLE
        Get-DattoRMMAccount

        Fetches the authenticated user's account data

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccount.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/account"

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri

    }

    end {}

}
#EndRegion '.\Public\Account\Get-DattoRMMAccount.ps1' 45
#Region '.\Public\Account\Get-DattoRMMAccountAlert.ps1' -1

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
#EndRegion '.\Public\Account\Get-DattoRMMAccountAlert.ps1' 144
#Region '.\Public\Account\Get-DattoRMMAccountComponent.ps1' -1

function Get-DattoRMMAccountComponent {
<#
    .SYNOPSIS
        Fetches the account components

    .DESCRIPTION
        The Get-DattoRMMAccountComponent cmdlet fetches the account components

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountComponent

        Gets the first 250 account components

    .EXAMPLE
        Get-DattoRMMAccountComponent -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountComponent.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
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

        $ResourceUri = "/account/components"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
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
#EndRegion '.\Public\Account\Get-DattoRMMAccountComponent.ps1' 89
#Region '.\Public\Account\Get-DattoRMMAccountDevice.ps1' -1

function Get-DattoRMMAccountDevice {
<#
    .SYNOPSIS
        Fetches the devices of the authenticated user's account.

    .DESCRIPTION
        The Get-DattoRMMAccountDevice cmdlet fetches the devices of
        the authenticated user's account

    .PARAMETER FilterId
        Filters results based on the provided device id

        If applied, this filter exclusively determines the results

    .PARAMETER Hostname
        Filters results based on the provided device hostname

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER DeviceType
        Filters results based on the provided device type

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER OperatingSystem
        Filters results based on the provided device OS

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER SiteName
        Filters results based on the provided site name

        Filters results based on the provided value using the LIKE operator
        Partial matches are allowed

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountDevice

        Gets the first 250 account sites

    .EXAMPLE
        Get-DattoRMMAccountDevice -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$FilterID,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Hostname,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceType,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$OperatingSystem,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteName,

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

        $ResourceUri = "/account/devices"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)              { $UriParameters['page']            = $Page }
            if ($Max)               { $UriParameters['max']             = $Max }
            if ($FilterID)          { $UriParameters['filterId']        = $FilterID }
            if ($Hostname)          { $UriParameters['hostname']        = $Hostname }
            if ($DeviceType)        { $UriParameters['deviceType']      = $DeviceType }
            if ($OperatingSystem)   { $UriParameters['operatingSystem'] = $OperatingSystem }
            if ($SiteName)          { $UriParameters['siteName']        = $SiteName }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Account\Get-DattoRMMAccountDevice.ps1' 144
#Region '.\Public\Account\Get-DattoRMMAccountDnetSiteMapping.ps1' -1

function Get-DattoRMMAccountDnetSiteMapping {
<#
    .SYNOPSIS
        Get the sites records with its mapped dnet network id for
        the authenticated user's account

    .DESCRIPTION
        The Get-DattoRMMAccountDnetSiteMapping cmdlet gets the sites records
        with its mapped dnet network id for the authenticated user's account

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountDnetSiteMapping

        Gets the first 250 account Dnet Site Mappings

    .EXAMPLE
        Get-DattoRMMAccountDnetSiteMapping -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountDnetSiteMapping.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
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

        $ResourceUri = "/account/dnet-site-mappings"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
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
#EndRegion '.\Public\Account\Get-DattoRMMAccountDnetSiteMapping.ps1' 91
#Region '.\Public\Account\Get-DattoRMMAccountSite.ps1' -1

function Get-DattoRMMAccountSite {
<#
    .SYNOPSIS
        Fetches the site records of the authenticated user's account

    .DESCRIPTION
        The Get-DattoRMMAccountSite cmdlet fetches the site records
        of the authenticated user's account

    .PARAMETER SiteName
        Filters results based on the provided value using the LIKE operator

        Partial matches are allowed

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountSite

        Gets the first 250 account sites

    .EXAMPLE
        Get-DattoRMMAccountSite -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountSite.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SiteName,

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

        $ResourceUri = "/account/sites"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)      { $UriParameters['page']    = $Page }
            if ($Max)       { $UriParameters['max']     = $Max }
            if ($SiteName)  { $UriParameters['siteName']= $SiteName }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Account\Get-DattoRMMAccountSite.ps1' 100
#Region '.\Public\Account\Get-DattoRMMAccountUser.ps1' -1

function Get-DattoRMMAccountUser {
<#
    .SYNOPSIS
        Fetches the authentication users records of the
        authenticated user's account

    .DESCRIPTION
        The Get-DattoRMMAccountUser cmdlet fetches the
        authentication users records of the authenticated user's account

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountUser

        Gets the first 250 account users

    .EXAMPLE
        Get-DattoRMMAccountUser -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountUser.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
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

        $ResourceUri = "/account/users"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
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
#EndRegion '.\Public\Account\Get-DattoRMMAccountUser.ps1' 91
#Region '.\Public\Account\Get-DattoRMMAccountVariable.ps1' -1

function Get-DattoRMMAccountVariable {
<#
    .SYNOPSIS
        Fetches the account variables

    .DESCRIPTION
        The Get-DattoRMMAccountVariable cmdlet fetches the account variables

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAccountVariable

        Gets the first 250 account variables

    .EXAMPLE
        Get-DattoRMMAccountVariable -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
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

        $ResourceUri = "/account/variables"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
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
#EndRegion '.\Public\Account\Get-DattoRMMAccountVariable.ps1' 89
#Region '.\Public\Account\New-DattoRMMAccountVariable.ps1' -1

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
#EndRegion '.\Public\Account\New-DattoRMMAccountVariable.ps1' 102
#Region '.\Public\Account\Remove-DattoRMMAccountVariable.ps1' -1

function Remove-DattoRMMAccountVariable {
<#
    .SYNOPSIS
        Deletes an account variable

    .DESCRIPTION
        The Remove-DattoRMMAccountVariable cmdlet deletes an account variable

    .PARAMETER VariableID
        ID of the variable

    .EXAMPLE
        Remove-DattoRMMAccountVariable -VariableID 12345

        Deletes the account variable with the defined Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Remove-DattoRMMAccountVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Delete', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [int64]$VariableID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/account/variable/$VariableID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
#EndRegion '.\Public\Account\Remove-DattoRMMAccountVariable.ps1' 59
#Region '.\Public\Account\Set-DattoRMMAccountVariable.ps1' -1

function Set-DattoRMMAccountVariable {
<#
    .SYNOPSIS
        Updates an account variable

    .DESCRIPTION
        The Set-DattoRMMAccountVariable cmdlet updates an account variable

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
        Set-DattoRMMAccountVariable -VariableID 12345 -Name 'VariableName' -Value 'VariableValue' -Masked

        Updates the account variable with the defined data

    .EXAMPLE
        Set-DattoRMMAccountVariable -Data $JsonBody

        Updates the account variable with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Account/Set-DattoRMMAccountVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
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

        $ResourceUri = "/account/variable/$VariableID"

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
#EndRegion '.\Public\Account\Set-DattoRMMAccountVariable.ps1' 102
#Region '.\Public\Activity-Logs\Get-DattoRMMActivityLog.ps1' -1

function Get-DattoRMMActivityLog {
<#
    .SYNOPSIS
        Fetches the activity logs

    .DESCRIPTION
        The Get-DattoRMMActivityLog cmdlet fetches the activity logs

    .PARAMETER Order
        Specifies the order in which records should be returned
        based on their creation date

        Allowed Values:
            asc
            desc

    .PARAMETER SearchAfter
        Acts as a pointer to determine the starting point for returning
        records from the database

        It is not advised to set this parameter manually
        Instead, it is recommended to utilize the 'prevPage' and 'nextPage' URLs that
        are returned in the response where this parameter in already included

    .PARAMETER From
        Defines the UTC start date for fetching data

        By default API returns logs from last 15 minutes

        Format: yyyy-MM-ddTHH:mm:ssZ

    .PARAMETER Until
        Defines the UTC end date for fetching data

        Format: yyyy-MM-ddTHH:mm:ssZ

    .PARAMETER Entities
        Filters the returned activity logs based on their type

        Allowed Values:
            device
            user

    .PARAMETER Categories
        Filters the returned activity logs based on their category

        Example Values:
            job
            device

    .PARAMETER Actions
        Filters the returned activity logs based on their action

        Example Values:
            deployment
            note

    .PARAMETER SiteIDs
        Filters the returned activity logs based on the site they were created in

    .PARAMETER UserIDs
        Filters the returned activity logs based on the user they are associated with

    .PARAMETER Page
        Return items starting from the defined page set

        Allowed Values:
            next
            previous

    .PARAMETER Size
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMActivityLog

        Returns logs from last 15 minutes

    .EXAMPLE
        Get-DattoRMMActivityLog -From (Get-Date).AddHours(-1)

        Returns logs from last hour

    .EXAMPLE
        Get-DattoRMMActivityLog -Size 100 -AllResults

        Gets all activity logs, 100 at a time

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Activity-Logs/Get-DattoRMMActivityLog.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false)]
        [ValidateSet('asc','desc')]
        [string]$Order,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SearchAfter,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [datetime]$From,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [datetime]$Until,

        [Parameter( Mandatory = $false)]
        [ValidateSet('device','user')]
        [string[]]$Entities,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Categories,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Actions,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$SiteIDs,

        [Parameter( Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserIDs,

        [Parameter( Mandatory = $false )]
        [ValidateSet('next','previous')]
        [string]$Page,

        [Parameter( Mandatory = $false)]
        [ValidateRange(1, 250)]
        [int]$Size,

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

        $ResourceUri = "/activity-logs"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)          { $UriParameters['page']        = $Page }
            if ($Size)           { $UriParameters['size']        = $Size }
            if ($Order)         { $UriParameters['order']       = $Order }
            if ($SearchAfter)   { $UriParameters['searchAfter'] = $SearchAfter }
            if ($From)          { $UriParameters['from']        = $From.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
            if ($Until)         { $UriParameters['until']       = $Until.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
            if ($Entities)      { $UriParameters['entities']    = $Entities -join ',' }
            if ($Categories)    { $UriParameters['categories']  = $Categories -join ',' }
            if ($Actions)       { $UriParameters['actions']     = $Actions -join ',' }
            if ($SiteIDs)       { $UriParameters['siteIds']     = $SiteIDs -join ',' }
            if ($UserIDs)       { $UriParameters['userIds']     = $UserIDs -join ',' }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter $UriParameters -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Activity-Logs\Get-DattoRMMActivityLog.ps1' 198
#Region '.\Public\Alert\Get-DattoRMMAlert.ps1' -1

function Get-DattoRMMAlert {
<#
    .SYNOPSIS
        Fetches data of the alert identified by the given alert Uid

    .DESCRIPTION
        The Get-DattoRMMAlert cmdlet fetches data of the alert
        identified by the given alert Uid

    .PARAMETER AlertUID
        Gets alerts from a specific alert udi

    .EXAMPLE
        Get-DattoRMMAlert

        Prompts for a specific alert uid to get the alert data

    .EXAMPLE
        Get-DattoRMMAlert -AlertUID '123456789'

        Gets the alert with the specific alert udi

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Alert/Get-DattoRMMAlert.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AlertUID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/alert/$AlertUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Alert\Get-DattoRMMAlert.ps1' 62
#Region '.\Public\Alert\Set-DattoRMMAlert.ps1' -1

function Set-DattoRMMAlert {
<#
    .SYNOPSIS
        Updates (resolves) an alert

    .DESCRIPTION
        The Set-DattoRMMAlert cmdlet updates (resolves) an alert

    .PARAMETER AlertUID
        UID of the alert

    .EXAMPLE
        Set-DattoRMMAlert -AlertUID 12345

        Updates (resolves) the alert with the defined Uid

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Alert/Set-DattoRMMAlert.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$AlertUID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/alert/$AlertUID/resolve"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method POST -ResourceURI $ResourceUri
        }

    }

    end {}

}
#EndRegion '.\Public\Alert\Set-DattoRMMAlert.ps1' 59
#Region '.\Public\Audit\Get-DattoRMMAuditDevice.ps1' -1

function Get-DattoRMMAuditDevice {
<#
    .SYNOPSIS
        Fetches audit data of the generic device identified the given device Uid

    .DESCRIPTION
        The Get-DattoRMMAuditDevice cmdlet fetches audit data of the
        generic device identified the given device Uid

        The device class must be of type "device"

    .PARAMETER DeviceUID
        Fetches audit data of the generic device identified
        the given device Uid

    .PARAMETER Software
        Fetches audited software of the generic device identified
        the given device Uid

    .PARAMETER MacAddress
        Fetches audit data of the generic device(s) identified by the given
        MAC address in format: XXXXXXXXXXXX

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMAuditDevice

        Prompts for a specific device uid to get audit data from

    .EXAMPLE
        Get-DattoRMMAuditDevice -DeviceUID '123456789'

        Returns audit data from the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditDevice -DeviceUID '123456789' -Software

        Returns software audit data from the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditDevice -MacAddress '00155DC07E1F'

        Returns audit data from the specific device with the given MAC address

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'DeviceOnly')]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceOnly' )]
        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceSoftware' )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $false,  ParameterSetName = 'DeviceSoftware' )]
        [switch]$Software,

        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceMacAddress' )]
        [ValidateNotNullOrEmpty()]
        [string]$MacAddress,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceSoftware' )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceSoftware' )]
        [ValidateRange(1, 250)]
        [int]$Max = 250,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceSoftware' )]
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
            'DeviceOnly'        { $ResourceUri = "/audit/device/$DeviceUID" }
            'DeviceSoftware'    { $ResourceUri = "/audit/device/$DeviceUID/software" }
            'DeviceMacAddress'  { $ResourceUri = "/audit/device/macAddress/$MacAddress" }

        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'DeviceSoftware') {
            if ($Page)  { $UriParameters['page']    = $Page }
            if ($Max)   { $UriParameters['max']     = $Max }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter:$UriParameters -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Audit\Get-DattoRMMAuditDevice.ps1' 131
#Region '.\Public\Audit\Get-DattoRMMAuditESXI.ps1' -1

function Get-DattoRMMAuditESXI {
<#
    .SYNOPSIS
        Fetches audit data of the ESXi host identified the given device Uid

    .DESCRIPTION
        The Get-DattoRMMAuditESXI cmdlet fetches audit data of the
        ESXi host identified the given device Uid

        The device class must be of type "esxihost"

    .PARAMETER DeviceUID
        Return a device with the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditESXI

        Prompts for a specific device uid to get audit data from

    .EXAMPLE
        Get-DattoRMMAuditESXI -DeviceUID '123456789'

        Returns audit data from the specific device uid

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditESXI.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/audit/esxihost/$DeviceUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Audit\Get-DattoRMMAuditESXI.ps1' 64
#Region '.\Public\Audit\Get-DattoRMMAuditPrint.ps1' -1

function Get-DattoRMMAuditPrinter {
<#
    .SYNOPSIS
        Fetches audit data of the printer identified with the given device Uid

    .DESCRIPTION
        The Get-DattoRMMAuditPrinter cmdlet fetches audit data of the
        printer identified the given device Uid

        The device class must be of type "printer"

    .PARAMETER DeviceUID
        Return a device with the specific device uid

    .EXAMPLE
        Get-DattoRMMAuditPrinter

        Prompts for a specific device uid to get audit data from

    .EXAMPLE
        Get-DattoRMMAuditPrinter -DeviceUID '123456789'

        Returns audit data from the specific device uid

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditPrinter.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/audit/printer/$DeviceUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Audit\Get-DattoRMMAuditPrint.ps1' 64
#Region '.\Public\Device\Get-DattoRMMDevice.ps1' -1

function Get-DattoRMMDevice {
<#
    .SYNOPSIS
        Fetches data of the device identified by the given device Uid

    .DESCRIPTION
        The Get-DattoRMMDevice cmdlet fetches data of the device
        identified by the given device Uid

    .PARAMETER DeviceUID
        Fetches data of the device identified by the given device Uid

    .PARAMETER DeviceID
        Fetches data of the device identified by the given device Id

    .PARAMETER MacAddress
        Fetches data of the device(s) identified by the given MAC address

        Format: XXXXXXXXXXXX

    .EXAMPLE
        Get-DattoRMMDevice

        Prompts for a device Uid and fetches data of the device

    .EXAMPLE
        Get-DattoRMMDevice -DeviceID '123456789'

        Fetches data for the specific device Id

    .EXAMPLE
        Get-DattoRMMDevice -MacAddress '00155DC07E1F'

        Fetches data for the specific device mac address

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'DeviceUID')]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceUID')]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceID')]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceID,

        [Parameter( Mandatory = $true, ParameterSetName = 'DeviceMacAddress')]
        [ValidateNotNullOrEmpty()]
        [string]$MacAddress
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'DeviceUID'     { $ResourceUri = "/device/$DeviceUID" }
            'DeviceID'      { $ResourceUri = "/device/id/$DeviceID" }
            'MacAddress'    { $ResourceUri = "/device/macAddress/$MacAddress" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Device\Get-DattoRMMDevice.ps1' 87
#Region '.\Public\Device\Get-DattoRMMDeviceAlert.ps1' -1

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
#EndRegion '.\Public\Device\Get-DattoRMMDeviceAlert.ps1' 151
#Region '.\Public\Device\Move-DattoRMMDevice.ps1' -1

function Move-DattoRMMDevice {
<#
    .SYNOPSIS
        Moves a device from one site to another site

    .DESCRIPTION
        The Move-DattoRMMDevice cmdlet moves a device from
        one site to another site

    .PARAMETER DeviceUID
        The UID of the device to move to a different site

    .PARAMETER SiteUID
        The UID of the target site

    .EXAMPLE
        Move-DattoRMMDevice -DeviceUID 12345 -SiteUID 6789

        Moves a device from one site to another site

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Move-DattoRMMDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Update', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/device/$DeviceUID/site/$SiteUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method PUT -ResourceURI $ResourceUri
        }

    }

    end {}

}
#EndRegion '.\Public\Device\Move-DattoRMMDevice.ps1' 67
#Region '.\Public\Device\New-DattoRMMDeviceJob.ps1' -1

function New-DattoRMMDeviceJob {
<#
    .SYNOPSIS
        Creates a quick job on the device identified by the given device Uid

    .DESCRIPTION
        The New-DattoRMMDeviceJob cmdlet creates a quick job on
        the device identified by the given device Uid

    .PARAMETER DeviceUID
        The UID of the device to create the quick job on

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        New-DattoRMMDeviceJob -DeviceUID 12345 -Data $JsonBody

        Creates a quick job on the device with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/New-DattoRMMDeviceJob.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Create', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true, ValueFromPipeline = $true )]
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

        $ResourceUri = "/device/$DeviceUID/quickjob"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $ParameterData -Value $Data -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method PUT -ResourceURI $ResourceUri -Data $Data
        }

    }

    end {}

}
#EndRegion '.\Public\Device\New-DattoRMMDeviceJob.ps1' 71
#Region '.\Public\Device\Set-DattoRMMDeviceUDF.ps1' -1

function Set-DattoRMMDeviceUDF {
<#
    .SYNOPSIS
        Sets the user defined fields of a device identified by
        the given device Uid

    .DESCRIPTION
        The Set-DattoRMMDeviceUDF cmdlet sets the user defined fields
        of a device identified by the given device Uid

        Any user defined field supplied with an empty value will be set to null
        All user defined fields not supplied will retain their current values

        DYNAMIC PARAMETERS
        -udf1 to -udf100 are created dynamically and will NOT appear in Get-Help

        Accepts string & null/empty values

        SYNTAX
        Set-DattoRMMDeviceUDF -DeviceUID <String> -udf1..100 <String> [-WhatIf] [-Confirm] [<CommonParameters>]

    .PARAMETER DeviceUID
        The UID of the device to create the quick job on

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        Set-DattoRMMDeviceUDF -DeviceUID 12345 -udf1 'Custom Value' -udf2 $null

        These are dynamically created parameters and will not appear in Get-Help

        Set the defined devices UDF's with the defined values

    .EXAMPLE
        Set-DattoRMMDeviceUDF -DeviceUID 12345 -Data $JsonBody

        Set the defined devices UDF's with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceUDF.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'UpdateData' )]
        $Data

    )

    DynamicParam {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        for ($i = 1; $i -le 100; $i++) {
            $paramName = "udf$i"

            #Allow for null values, used to clear UDFs
            $AllowNull = New-Object System.Management.Automation.AllowNullAttribute

            #Define properties for each parameter
            $Properties                     = New-Object System.Management.Automation.ParameterAttribute
            $Properties.Mandatory           = $false
            $Properties.ValueFromPipeline   = $true
            $Properties.ParameterSetName    = 'Update'

            #Define the parameter type and attach properties & other attributes
            $param = New-Object System.Management.Automation.RuntimeDefinedParameter(
                $paramName, [string[]], [System.Attribute[]]@($Properties,$AllowNull)
            )

            #Add to the dynamic parameter dictionary
            $paramDictionary.Add($paramName, $param)
        }

        return $paramDictionary
    }

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $ParameterData      = $FunctionName + '_Data' -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/device/$DeviceUID/udf"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Update') {

            $UDFs = @{}

            #Collect only the UDF parameters that were supplied
            foreach ($UDFKey in $PSBoundParameters.Keys) {

                if ($UDFKey -match '^udf\d+$') {

                    $UDFValue = $PSBoundParameters[$UDFKey]

                    #Convert to empty strings to null out UDF
                    if ([string]::IsNullOrWhiteSpace($UDFValue) -or $null -eq $UDFValue) {
                        $UDFs[$UDFKey] = ''
                    }
                    else { $UDFs[$UDFKey] = [string]$UDFValue }

                }

            }

            $Data = $UDFs

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
#EndRegion '.\Public\Device\Set-DattoRMMDeviceUDF.ps1' 146
#Region '.\Public\Device\Set-DattoRMMDeviceWarranty.ps1' -1

function Set-DattoRMMDeviceWarranty {
<#
    .SYNOPSIS
        Sets the warranty of a device identified by the given device Uid

    .DESCRIPTION
        The Set-DattoRMMDeviceWarranty cmdlet sets the warranty of a device
        identified by the given device Uid

        The warrantyDate field should be a ISO 8601 string with this format: yyyy-mm-dd
        The warranty date can also be set to null

    .PARAMETER DeviceUID
        The UID of the device to create the quick job on

    .PARAMETER WarrantyDate
        The new warranty date that can also be set to null

        The warrantyDate field should be a ISO 8601 string with this format: yyyy-mm-dd

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        Set-DattoRMMDeviceWarranty -DeviceUID 12345 -WarrantyDate '2025-01-01'

        Sets the warranty of a device identified by the given device Uid

    .EXAMPLE
        Set-DattoRMMDeviceWarranty -DeviceUID 12345 -WarrantyDate $null

        Sets the warranty of a device identified by the given device Uid

    .EXAMPLE
        Set-DattoRMMDeviceWarranty -DeviceUID 12345 -Data $JsonBody

        Creates a quick job on the device with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceWarranty.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $true, ParameterSetName = 'Update' )]
        [AllowNull()]
        [Nullable[datetime]]$WarrantyDate,

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

        $ResourceUri = "/device/$DeviceUID/warranty"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Update') {

            $Data = [PSCustomObject]@{
                warrantyDate = if($WarrantyDate){$WarrantyDate.ToString('yyyy-MM-dd')}else{$null}
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
#EndRegion '.\Public\Device\Set-DattoRMMDeviceWarranty.ps1' 105
#Region '.\Public\Filter\Get-DattoRMMFilter.ps1' -1

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
#EndRegion '.\Public\Filter\Get-DattoRMMFilter.ps1' 135
#Region '.\Public\Job\Get-DattoRMMJob.ps1' -1

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
#EndRegion '.\Public\Job\Get-DattoRMMJob.ps1' 114
#Region '.\Public\Job\Get-DattoRMMJobResult.ps1' -1

function Get-DattoRMMJobResult {
<#
    .SYNOPSIS
        Fetches job results of the job identified by the job Uid
        for device identified by the device Uid

    .DESCRIPTION
        The Get-DattoRMMJobResult cmdlet fetches data of the job
        identified by the given job Uid

        JobUID is returned when creating jobs via other cmdlets

    .PARAMETER JobUID
        Fetches data of the job identified by the given job Uid

    .PARAMETER DeviceUID
        Fetches data of the job identified by the given device Uid

    .PARAMETER STDOUT
        Return jobs results from stdout

    .PARAMETER STDERR
        Return jobs results from stderr

    .EXAMPLE
        Get-DattoRMMJobResult

        Prompts for a job & device Uid and fetches data of the job

    .EXAMPLE
        Get-DattoRMMJobResult -JobUID '123456789' -DeviceUID '987654321'

        Fetches data for the specific device job Uid

    .EXAMPLE
        Get-DattoRMMJobResult -JobUID '123456789' -DeviceUID '987654321' -STDOUT

        Fetches stdout results for the specific device job Uid

    .EXAMPLE
        Get-DattoRMMJobResult -JobUID '123456789' -DeviceUID '987654321' -STDERR

        Fetches stderr results for the specific device job Uid

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJobResult.html

#>

    [CmdletBinding(DefaultParameterSetName = 'JobResultsOnly')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$JobUID,

        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$DeviceUID,

        [Parameter( Mandatory = $false, ParameterSetName = 'JobStdOutOnly' )]
        [switch]$STDOUT,

        [Parameter( Mandatory = $false, ParameterSetName = 'JobStdErrOnly' )]
        [switch]$STDERR
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'JobResultsOnly'    { $ResourceUri = "/job/$JobUID/results/$DeviceID" }
            'JobStdOutOnly'     { $ResourceUri = "/job/$JobUID/results/$DeviceID/stdout" }
            'JobStdErrOnly'     { $ResourceUri = "/job/$JobUID/results/$DeviceID/stderr" }
        }

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Job\Get-DattoRMMJobResult.ps1' 98
#Region '.\Public\Site\Get-DattoRMMSite.ps1' -1

function Get-DattoRMMSite {
<#
    .SYNOPSIS
        Fetches data of the site (including total number of devices)
        identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSite cmdlet fetches data of the site
        (including total number of devices) identified by the given site Uid

    .PARAMETER SiteUID
        Fetches data of a  specific site identified by the given site Uid

    .EXAMPLE
        Get-DattoRMMSite

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSite -SiteUID '123456789'

        Fetches data for the specific site Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSite.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/site/$SiteUID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Site\Get-DattoRMMSite.ps1' 63
#Region '.\Public\Site\Get-DattoRMMSiteAlert.ps1' -1

function Get-DattoRMMSiteAlert {
<#
    .SYNOPSIS
        Fetches the alerts of the site identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSiteAlert cmdlet fetches the alerts of the site
        identified by the given site Uid

        By default only open alerts are returned

    .PARAMETER AlertType
        Fetches data of the specific alert type

        Allowed values:
            'All'
            'Resolved'
            'Open'

    .PARAMETER SiteUID
        Fetches data of the alert identified by the given site Id

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
        Get-DattoRMMSiteAlert

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSiteAlert -SiteUID '123456789'

        Fetches data for the specific site Uid

    .EXAMPLE
        Get-DattoRMMAccountAlert -SiteUID '123456789' -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteAlert.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet('All','Resolved','Open')]
        [string]$AlertType = 'Open',

        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

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
            'All'       { $ResourceUri = @("/site/$SiteUID/alerts/resolved","/site/$SiteUID/alerts/open") }
            'Resolved'  { $ResourceUri = "/site/$SiteUID/alerts/resolved" }
            'Open'      { $ResourceUri = "/site/$SiteUID/alerts/open" }
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
#EndRegion '.\Public\Site\Get-DattoRMMSiteAlert.ps1' 153
#Region '.\Public\Site\Get-DattoRMMSiteDevice.ps1' -1

function Get-DattoRMMSiteDevice {
<#
    .SYNOPSIS
        Fetches the devices records of the site identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSiteDevice cmdlet fetches the devices records of the
        site identified by the given site Uid

    .PARAMETER SiteUID
        Fetches data of a specific site identified by the given site Uid

    .PARAMETER FilterID
        Fetches data of a specific site device identified by the given device Id

    .PARAMETER NetworkInterface
        Fetches the shortened devices records with network interface information
        of the site identified by the given site Uid

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMSiteDevice

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSiteDevice -SiteUID '123456789'

        Fetches data for the specific site Id

    .EXAMPLE
        Get-DattoRMMAccountAlert -SiteUID '123456789' -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteDevice.html

#>

    [CmdletBinding(DefaultParameterSetName = 'DeviceOnly')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceOnly' )]
        [ValidateNotNullOrEmpty()]
        [string]$FilterID,

        [Parameter( Mandatory = $false, ParameterSetName = 'DeviceNetworkInterface' )]
        [switch]$NetworkInterface,

        [Parameter( Mandatory = $false )]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Page,

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

        switch ($PSCmdlet.ParameterSetName){
            'DeviceOnly'                { $ResourceUri = "/site/$SiteUID/devices" }
            'DeviceNetworkInterface'    { $ResourceUri = "/site/$SiteUID/devices/network-interface" }
        }

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($Page)  { $UriParameters['page']    = $Page }
        if ($Max)   { $UriParameters['max']     = $Max }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter:$UriParameters -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Site\Get-DattoRMMSiteDevice.ps1' 117
#Region '.\Public\Site\Get-DattoRMMSiteFilter.ps1' -1

function Get-DattoRMMSiteFilter {
<#
    .SYNOPSIS
        Fetches the site device filters (that the user can see with administrator role)
        of the site identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSiteFilter cmdlet fetches the site device filters
        (that the user can see with administrator role) of the site identified
        by the given site Uid

    .PARAMETER SiteUID
        Fetches data of a specific site identified by the given site Uid

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMSiteFilter

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSiteFilter -SiteUID '123456789'

        Fetches data for the specific site Id

    .EXAMPLE
        Get-DattoRMMAccountAlert -SiteUID '123456789' -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteFilter.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

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

        $ResourceUri = "/site/$SiteUID/filters"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)  { $UriParameters['page']    = $Page }
            if ($Max)   { $UriParameters['max']     = $Max }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter:$UriParameters -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Site\Get-DattoRMMSiteFilter.ps1' 104
#Region '.\Public\Site\Get-DattoRMMSiteSetting.ps1' -1

function Get-DattoRMMSiteSetting {
<#
    .SYNOPSIS
        Fetches settings of the site identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSiteSetting cmdlet fetches settings of the site
        identified by the given site Uid

    .PARAMETER SiteUID
        Fetches data of a specific site identified by the given site Uid

    .EXAMPLE
        Get-DattoRMMSiteSetting

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSiteSetting -SiteUID '123456789'

        Fetches data for the specific site Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteSetting.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/site/$SiteUID/settings"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Site\Get-DattoRMMSiteSetting.ps1' 62
#Region '.\Public\Site\Get-DattoRMMSiteVariable.ps1' -1

function Get-DattoRMMSiteVariable {
<#
    .SYNOPSIS
        Fetches the variables of the site identified by the given site Uid

    .DESCRIPTION
        The Get-DattoRMMSiteVariable cmdlet fetches the variables of the site
        identified by the given site Uid

    .PARAMETER SiteUID
        Fetches data of a specific site identified by the given site Uid

    .PARAMETER Page
        Return items starting from the defined page number

    .PARAMETER Max
        Return the first N items

        Allowed Value: 1-250

    .PARAMETER AllResults
        Returns all items from an endpoint

        Highly recommended to only use with filters to reduce API errors\timeouts

    .EXAMPLE
        Get-DattoRMMSiteVariable

        Prompts for a site Uid and fetches data of the site

    .EXAMPLE
        Get-DattoRMMSiteVariable -SiteUID '123456789'

        Fetches data for the specific site Id

    .EXAMPLE
        Get-DattoRMMAccountAlert -SiteUID '123456789' -Page 2 -Max 5

        Get the first defined number of items from the define page

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

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

        $ResourceUri = "/site/$SiteUID/variables"

        $UriParameters = @{}

        #Region     [ Parameter Translation ]

        if ($PSCmdlet.ParameterSetName -eq 'Index') {
            if ($Page)  { $UriParameters['page']    = $Page }
            if ($Max)   { $UriParameters['max']     = $Max }
        }

        #EndRegion  [ Parameter Translation ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        return Invoke-DattoRMMRequest -Method GET -ResourceURI $ResourceUri -UriFilter:$UriParameters -AllResults:$AllResults

    }

    end {}

}
#EndRegion '.\Public\Site\Get-DattoRMMSiteVariable.ps1' 102
#Region '.\Public\Site\New-DattoRMMSite.ps1' -1

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
#EndRegion '.\Public\Site\New-DattoRMMSite.ps1' 113
#Region '.\Public\Site\New-DattoRMMSiteVariable.ps1' -1

function New-DattoRMMSiteVariable {
<#
    .SYNOPSIS
        Creates a site variable in the site identified by the
        given site Uid

    .DESCRIPTION
        The New-DattoRMMSiteVariable cmdlet creates a site variable
        in the site identified by the given site Uid

    .PARAMETER SiteUID
        UID of the site

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
        New-DattoRMMSiteVariable -Name 'VariableName' -Value 'VariableValue' -Masked

        Create a new masked site variable with the defined data

    .EXAMPLE
        New-DattoRMMSiteVariable -Data $JsonBody

        Create a new site variable with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/New-DattoRMMSiteVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'CreateData', SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'Create')]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

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

        $ResourceUri = "/site/$SiteUID/variable"

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
#EndRegion '.\Public\Site\New-DattoRMMSiteVariable.ps1' 111
#Region '.\Public\Site\Remove-DattoRMMSiteProxy.ps1' -1

function Remove-DattoRMMSiteProxy {
<#
    .SYNOPSIS
        Deletes site proxy settings for the site identified by the given site Uid

    .DESCRIPTION
        The Remove-DattoRMMSiteProxy cmdlet deletes site proxy settings
        for the site identified by the given site Uid

    .PARAMETER SiteUID
        UID of the site

    .EXAMPLE
        Remove-DattoRMMSiteProxy -SiteUID 12345

        Deletes the site proxy settings with the defined Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteProxy.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Delete', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/site/$SiteUID/settings/proxy"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
#EndRegion '.\Public\Site\Remove-DattoRMMSiteProxy.ps1' 60
#Region '.\Public\Site\Remove-DattoRMMSiteVariable.ps1' -1

function Remove-DattoRMMSiteVariable {
<#
    .SYNOPSIS
        Deletes the site variable identified by the given site Uid and variable Id

    .DESCRIPTION
        The Remove-DattoRMMSiteVariable cmdlet deletes the site variable
        identified by the given site Uid and variable Id

    .PARAMETER SiteUID
        UID of the site

    .PARAMETER VariableID
        ID of the variable

    .EXAMPLE
        Remove-DattoRMMSiteVariable -SiteUID 12345 -VariableID 12345

        Deletes the site variable identified by the given site Uid and variable Id

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteVariable.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Delete', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [int64]$VariableID

    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/site/$SiteUID/variable/$VariableID"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method DELETE -ResourceURI $ResourceUri
        }

    }

    end {}

}
#EndRegion '.\Public\Site\Remove-DattoRMMSiteVariable.ps1' 67
#Region '.\Public\Site\Set-DattoRMMSite.ps1' -1

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
#EndRegion '.\Public\Site\Set-DattoRMMSite.ps1' 120
#Region '.\Public\Site\Set-DattoRMMSiteProxy.ps1' -1

function Set-DattoRMMSiteProxy {
<#
    .SYNOPSIS
        Creates/updates the proxy settings for the site identified
        by the given site Uid

    .DESCRIPTION
        The Set-DattoRMMSiteProxy cmdlet creates/updates the proxy settings
        for the site identified by the given site Uid

    .PARAMETER SiteUID
        UID of the site

    .PARAMETER ProxyHost
        Proxy host address

    .PARAMETER Port
        Proxy port

    .PARAMETER Type
        Proxy type, this is case sensitive

        Allowed values:
            http
            socks4
            socks5

    .PARAMETER UserName
        Proxy username

    .PARAMETER Password
        Proxy password

    .PARAMETER Data
        JSON body

        Do NOT include the "Data" property in the JSON object as this is handled
        by the Invoke-DattoRMMRequest function

    .EXAMPLE
        Set-DattoRMMSiteProxy -SiteUID 12345 -Host proxy.celerium.org -UserName 'Celerium' -Password 'Password' -Port 8080 -Type socks5

        Updates/creates the site proxy settings with the defined data

    .EXAMPLE
        Set-DattoRMMSiteProxy -Data $JsonBody

        Updates/creates the site proxy settings with the structured JSON object

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteProxy.html

#>

    [CmdletBinding(DefaultParameterSetName = 'UpdateData', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    Param (
        [Parameter( Mandatory = $true )]
        [ValidateNotNullOrEmpty()]
        [string]$SiteUID,

        [Parameter( Mandatory = $true, ParameterSetName = 'Update' )]
        [ValidateSet( 'http', 'socks4', 'socks5', IgnoreCase = $false )]
        [string]$Type,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [string]$ProxyHost,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [int]$Port,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [string]$UserName,

        [Parameter( Mandatory = $false, ParameterSetName = 'Update' )]
        [AllowNull()]
        [string]$Password,

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

        $ResourceUri = "/site/$SiteUID/settings/proxy"

        #Region     [ Data Construction ]

        if ($PSCmdlet.ParameterSetName -eq 'Update') {

            $Data = [PSCustomObject]@{
                host        = $ProxyHost
                password    = $Password
                port        = $Port
                type        = $Type
                username    = $UserName
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
#EndRegion '.\Public\Site\Set-DattoRMMSiteProxy.ps1' 133
#Region '.\Public\Site\Set-DattoRMMSiteVariable.ps1' -1

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
#EndRegion '.\Public\Site\Set-DattoRMMSiteVariable.ps1' 111
#Region '.\Public\System\Get-DattoRMMSystem.ps1' -1

function Get-DattoRMMSystem {
<#
    .SYNOPSIS
        Gets various DattoRMM system operation information

    .DESCRIPTION
        The Get-DattoRMMSystem cmdlet gets various DattoRMM
        system operation information

    .PARAMETER Status
        Fetches the system status (start date, status and version)

    .PARAMETER RequestRate
        Fetches the request rate status for the authenticated user's account

    .PARAMETER Pagination
        Fetches the pagination configurations

    .EXAMPLE
        Get-DattoRMMSystem

        Fetches the system status (start date, status and version)

    .EXAMPLE
        Get-DattoRMMSystem -RequestRate

        Fetches the request rate status for the authenticated user's account

    .EXAMPLE
        Get-DattoRMMSystem -Pagination

        Fetches the pagination configurations

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/System/Get-DattoRMMSystem.html

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
#EndRegion '.\Public\System\Get-DattoRMMSystem.ps1' 84
#Region '.\Public\User\Reset-DattoRMMUserApiKey.ps1' -1

function Reset-DattoRMMUserApiKey {
<#
    .SYNOPSIS
        Resets the authenticated user's API access and secret keys

    .DESCRIPTION
        The Reset-DattoRMMUserApiKey cmdlet resets the authenticated user's
        API access and secret keys

        This will return the new access & secret keys

    .EXAMPLE
        Reset-DattoRMMUserApiKey

        Resets the authenticated user's API access and secret keys
        and returns them to the console

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Celerium.DattoRMM/site/User/Reset-DattoRMMUserApiKey.html

#>

    [CmdletBinding(DefaultParameterSetName = 'Reset', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $FunctionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $FunctionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $ResourceUri = "/user/resetApiKeys"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $UriParameters -Scope Global -Force -Confirm:$false

        if ($PSCmdlet.ShouldProcess($ResourceUri)) {
            return Invoke-DattoRMMRequest -Method POST -ResourceURI $ResourceUri
        }

    }

    end {}

}
#EndRegion '.\Public\User\Reset-DattoRMMUserApiKey.ps1' 55
