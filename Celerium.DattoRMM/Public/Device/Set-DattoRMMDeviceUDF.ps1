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
        The UID of the device

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
