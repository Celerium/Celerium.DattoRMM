---
external help file: Celerium.DattoRMM-help.xml
grand_parent: System
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/System/Get-DattoRMMSystem.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMSystem
---

# Get-DattoRMMSystem

## SYNOPSIS
Gets various DattoRMM system operation information

## SYNTAX

### Status (Default)
```powershell
Get-DattoRMMSystem [-Status] [<CommonParameters>]
```

### RequestRate
```powershell
Get-DattoRMMSystem [-RequestRate] [<CommonParameters>]
```

### Pagination
```powershell
Get-DattoRMMSystem [-Pagination] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMSystem cmdlet gets various DattoRMM
system operation information

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMSystem
```

Fetches the system status (start date, status and version)

### EXAMPLE 2
```powershell
Get-DattoRMMSystem -RequestRate
```

Fetches the request rate status for the authenticated user's account

### EXAMPLE 3
```powershell
Get-DattoRMMSystem -Pagination
```

Fetches the pagination configurations

## PARAMETERS

### -Status
Fetches the system status (start date, status and version)

```yaml
Type: SwitchParameter
Parameter Sets: Status
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestRate
Fetches the request rate status for the authenticated user's account

```yaml
Type: SwitchParameter
Parameter Sets: RequestRate
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pagination
Fetches the pagination configurations

```yaml
Type: SwitchParameter
Parameter Sets: Pagination
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

[https://celerium.github.io/Celerium.DattoRMM/site/System/Get-DattoRMMSystem.html](https://celerium.github.io/Celerium.DattoRMM/site/System/Get-DattoRMMSystem.html)

