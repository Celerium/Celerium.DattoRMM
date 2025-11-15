---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Job
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJob.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMJob
---

# Get-DattoRMMJob

## SYNOPSIS
Fetches data of the job identified by the given job Uid

## SYNTAX

### JobOnly (Default)
```powershell
Get-DattoRMMJob -JobUID <String> [<CommonParameters>]
```

### JobComponent
```powershell
Get-DattoRMMJob -JobUID <String> [-Component] [-Page <Int32>] [-Max <Int32>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMJob cmdlet fetches data of the job
identified by the given job Uid

JobUID is returned when creating jobs via other cmdlets

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMJob
```

Prompts for a job Uid and fetches data of the job

### EXAMPLE 2
```powershell
Get-DattoRMMJob -JobUID '123456789'
```

Fetches data for the specific job Id

### EXAMPLE 3
```powershell
Get-DattoRMMAccountAlert -Page 2 -Max 5
```

Get the first defined number of items from the define page

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

### -Component
Fetches components of the job

```yaml
Type: SwitchParameter
Parameter Sets: JobComponent
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
Return items starting from the defined page number

```yaml
Type: Int32
Parameter Sets: JobComponent
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Max
Return the first N items

Allowed Value: 1-250

```yaml
Type: Int32
Parameter Sets: JobComponent
Aliases:

Required: False
Position: Named
Default value: 250
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllResults
Returns all items from an endpoint

Highly recommended to only use with filters to reduce API errors\timeouts

```yaml
Type: SwitchParameter
Parameter Sets: JobComponent
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

[https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJob.html](https://celerium.github.io/Celerium.DattoRMM/site/Job/Get-DattoRMMJob.html)

