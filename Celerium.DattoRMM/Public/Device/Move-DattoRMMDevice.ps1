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
