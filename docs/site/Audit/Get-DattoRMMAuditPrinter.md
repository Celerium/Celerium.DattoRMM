---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Audit
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditPrinter.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMAuditPrinter
---

# Get-DattoRMMAuditPrinter

## SYNOPSIS
Fetches audit data of the printer identified with the given device Uid

## SYNTAX

```powershell
Get-DattoRMMAuditPrinter [-DeviceUID] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMAuditPrinter cmdlet fetches audit data of the
printer identified the given device Uid

The device class must be of type "printer"

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMAuditPrinter
```

Prompts for a specific device uid to get audit data from

### EXAMPLE 2
```powershell
Get-DattoRMMAuditPrinter -DeviceUID '123456789'
```

Returns audit data from the specific device uid

## PARAMETERS

### -DeviceUID
Return a device with the specific device uid

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

[https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditPrinter.html](https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditPrinter.html)

