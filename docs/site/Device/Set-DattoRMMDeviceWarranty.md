---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Device
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceWarranty.html
parent: POST
schema: 2.0.0
title: Set-DattoRMMDeviceWarranty
---

# Set-DattoRMMDeviceWarranty

## SYNOPSIS
Sets the warranty of a device identified by the given device Uid

## SYNTAX

### UpdateData (Default)
```powershell
Set-DattoRMMDeviceWarranty -DeviceUID <String> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-DattoRMMDeviceWarranty -DeviceUID <String> -WarrantyDate <DateTime> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-DattoRMMDeviceWarranty cmdlet sets the warranty of a device
identified by the given device Uid

The warrantyDate field should be a ISO 8601 string with this format: yyyy-mm-dd
The warranty date can also be set to null

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoRMMDeviceWarranty -DeviceUID 12345 -WarrantyDate '2025-01-01'
```

Sets the warranty of a device identified by the given device Uid

### EXAMPLE 2
```powershell
Set-DattoRMMDeviceWarranty -DeviceUID 12345 -WarrantyDate $null
```

Sets the warranty of a device identified by the given device Uid

### EXAMPLE 3
```powershell
Set-DattoRMMDeviceWarranty -DeviceUID 12345 -Data $JsonBody
```

Creates a quick job on the device with the structured JSON object

## PARAMETERS

### -DeviceUID
The UID of the device to create the quick job on

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

### -WarrantyDate
The new warranty date that can also be set to null

The warrantyDate field should be a ISO 8601 string with this format: yyyy-mm-dd

```yaml
Type: DateTime
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
JSON body

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-DattoRMMRequest function

```yaml
Type: Object
Parameter Sets: UpdateData
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
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

[https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceWarranty.html](https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceWarranty.html)

