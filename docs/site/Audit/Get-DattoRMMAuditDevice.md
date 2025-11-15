---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Audit
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditDevice.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMAuditDevice
---

# Get-DattoRMMAuditDevice

## SYNOPSIS
Fetches audit data of the generic device identified the given device Uid

## SYNTAX

### DeviceOnly (Default)
```powershell
Get-DattoRMMAuditDevice -DeviceUID <String> [<CommonParameters>]
```

### DeviceSoftware
```powershell
Get-DattoRMMAuditDevice -DeviceUID <String> [-Software] [-Page <Int32>] [-Max <Int32>] [-AllResults]
 [<CommonParameters>]
```

### DeviceMacAddress
```powershell
Get-DattoRMMAuditDevice -MacAddress <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMAuditDevice cmdlet fetches audit data of the
generic device identified the given device Uid

The device class must be of type "device"

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMAuditDevice
```

Prompts for a specific device uid to get audit data from

### EXAMPLE 2
```powershell
Get-DattoRMMAuditDevice -DeviceUID '123456789'
```

Returns audit data from the specific device uid

### EXAMPLE 3
```powershell
Get-DattoRMMAuditDevice -DeviceUID '123456789' -Software
```

Returns software audit data from the specific device uid

### EXAMPLE 4
```powershell
Get-DattoRMMAuditDevice -MacAddress '00155DC07E1F'
```

Returns audit data from the specific device with the given MAC address

## PARAMETERS

### -DeviceUID
Fetches audit data of the generic device identified
the given device Uid

```yaml
Type: String
Parameter Sets: DeviceOnly, DeviceSoftware
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Software
Fetches audited software of the generic device identified
the given device Uid

```yaml
Type: SwitchParameter
Parameter Sets: DeviceSoftware
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacAddress
Fetches audit data of the generic device(s) identified by the given
MAC address in format: XXXXXXXXXXXX

```yaml
Type: String
Parameter Sets: DeviceMacAddress
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
Return items starting from the defined page number

```yaml
Type: Int32
Parameter Sets: DeviceSoftware
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
Parameter Sets: DeviceSoftware
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
Parameter Sets: DeviceSoftware
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

[https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditDevice.html](https://celerium.github.io/Celerium.DattoRMM/site/Audit/Get-DattoRMMAuditDevice.html)

