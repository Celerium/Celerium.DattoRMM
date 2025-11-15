---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Device
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDeviceAlert.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMDeviceAlert
---

# Get-DattoRMMDeviceAlert

## SYNOPSIS
Fetches the alerts of the device identified by the given device Uid

## SYNTAX

```powershell
Get-DattoRMMDeviceAlert [[-AlertType] <String>] [-DeviceUID] <String> [-Muted] [[-Page] <Int32>]
 [[-Max] <Int32>] [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMDeviceAlert cmdlet fetches the alerts of the device
identified by the given device Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMDeviceAlert
```

Prompts for a device Uid and fetches data of the device

### EXAMPLE 2
```powershell
Get-DattoRMMDeviceAlert -DeviceUID '123456789'
```

Fetches data for the specific device Uid

### EXAMPLE 3
```powershell
Get-DattoRMMDeviceAlert -MacAddress '00155DC07E1F'
```

Fetches data for the specific device mac address

## PARAMETERS

### -AlertType
Fetches data of the specific alert type

Allowed values:
    'All'
    'Resolved'
    'Open'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Open
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceUID
Fetches data of the alert identified by the given device Id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Muted
Fetches data of muted alerts

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Max
Return the first N items

Allowed Value: 1-250

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 250
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllResults
Returns all items from an endpoint

Highly recommended to only use with filters to reduce API errors\timeouts

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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

[https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDeviceAlert.html](https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDeviceAlert.html)

