---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Device
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevice.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMDevice
---

# Get-DattoRMMDevice

## SYNOPSIS
Fetches data of the device identified by the given device Uid

## SYNTAX

### DeviceUID (Default)
```powershell
Get-DattoRMMDevice -DeviceUID <String> [<CommonParameters>]
```

### DeviceID
```powershell
Get-DattoRMMDevice -DeviceID <String> [<CommonParameters>]
```

### DeviceMacAddress
```powershell
Get-DattoRMMDevice -MacAddress <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMDevice cmdlet fetches data of the device
identified by the given device Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMDevice
```

Prompts for a device Uid and fetches data of the device

### EXAMPLE 2
```powershell
Get-DattoRMMDevice -DeviceID '123456789'
```

Fetches data for the specific device Id

### EXAMPLE 3
```powershell
Get-DattoRMMDevice -MacAddress '00155DC07E1F'
```

Fetches data for the specific device mac address

## PARAMETERS

### -DeviceUID
Fetches data of the device identified by the given device Uid

```yaml
Type: String
Parameter Sets: DeviceUID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceID
Fetches data of the device identified by the given device Id

```yaml
Type: String
Parameter Sets: DeviceID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MacAddress
Fetches data of the device(s) identified by the given MAC address

Format: XXXXXXXXXXXX

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevice.html](https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevice.html)

