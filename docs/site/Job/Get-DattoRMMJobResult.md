---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Job
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJobResult.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMJobResult
---

# Get-DattoRMMJobResult

## SYNOPSIS
Fetches job results of the job identified by the job Uid
for device identified by the device Uid

## SYNTAX

### JobResultsOnly (Default)
```powershell
Get-DattoRMMJobResult -JobUID <String> -DeviceUID <String> [<CommonParameters>]
```

### JobStdOutOnly
```powershell
Get-DattoRMMJobResult -JobUID <String> -DeviceUID <String> [-STDOUT] [<CommonParameters>]
```

### JobStdErrOnly
```powershell
Get-DattoRMMJobResult -JobUID <String> -DeviceUID <String> [-STDERR] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMJobResult cmdlet fetches data of the job
identified by the given job Uid

JobUID is returned when creating jobs via other cmdlets

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMJobResult
```

Prompts for a job & device Uid and fetches data of the job

### EXAMPLE 2
```powershell
Get-DattoRMMJobResult -JobUID '123456789' -DeviceUID '987654321'
```

Fetches data for the specific device job Uid

### EXAMPLE 3
```powershell
Get-DattoRMMJobResult -JobUID '123456789' -DeviceUID '987654321' -STDOUT
```

Fetches stdout results for the specific device job Uid

### EXAMPLE 4
```powershell
Get-DattoRMMJobResult -JobUID '123456789' -DeviceUID '987654321' -STDERR
```

Fetches stderr results for the specific device job Uid

## PARAMETERS

### -JobUID
Fetches data of the job identified by the given job Uid

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceUID
Fetches data of the job identified by the given device Uid

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -STDOUT
Return jobs results from stdout

```yaml
Type: SwitchParameter
Parameter Sets: JobStdOutOnly
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -STDERR
Return jobs results from stderr

```yaml
Type: SwitchParameter
Parameter Sets: JobStdErrOnly
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJobResult.html](https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJobResult.html)

