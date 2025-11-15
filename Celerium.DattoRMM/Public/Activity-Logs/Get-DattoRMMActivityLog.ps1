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
