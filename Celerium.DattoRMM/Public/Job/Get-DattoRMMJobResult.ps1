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
