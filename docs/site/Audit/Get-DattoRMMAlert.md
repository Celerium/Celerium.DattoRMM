---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Audit
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAlert.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMAlert
---

# Get-DattoRMMAlert

## SYNOPSIS
Fetches data of the alert identified by the given alert Uid

## SYNTAX

```powershell
Get-DattoRMMAlert [-AlertUID] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMAlert cmdlet fetches data of the alert
identified by the given alert Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMAlert
```

Prompts for a specific alert uid to get the alert data

### EXAMPLE 2
```powershell
Get-DattoRMMAlert -AlertUID '123456789'
```

Gets the alert with the specific alert udi

## PARAMETERS

### -AlertUID
Gets alerts from a specific alert udi

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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

[https://celerium.github.io/Celerium.DattoRMM/site/Alert/Get-DattoRMMAlert.html](https://celerium.github.io/Celerium.DattoRMM/site/Alert/Get-DattoRMMAlert.html)

