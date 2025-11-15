---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Audit
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditESXI.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMAuditESXI
---

# Get-DattoRMMAuditESXI

## SYNOPSIS
Fetches audit data of the ESXi host identified the given device Uid

## SYNTAX

```powershell
Get-DattoRMMAuditESXI [-DeviceUID] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMAuditESXI cmdlet fetches audit data of the
ESXi host identified the given device Uid

The device class must be of type "esxihost"

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMAuditESXI
```

Prompts for a specific device uid to get audit data from

### EXAMPLE 2
```powershell
Get-DattoRMMAuditESXI -DeviceUID '123456789'
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

[https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditESXI.html](https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditESXI.html)

