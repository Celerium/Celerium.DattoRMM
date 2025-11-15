---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Device
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Device/New-DattoRMMDeviceJob.html
parent: PUT
schema: 2.0.0
title: New-DattoRMMDeviceJob
---

# New-DattoRMMDeviceJob

## SYNOPSIS
Creates a quick job on the device identified by the given device Uid

## SYNTAX

```powershell
New-DattoRMMDeviceJob [-DeviceUID] <String> [-Data] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-DattoRMMDeviceJob cmdlet creates a quick job on
the device identified by the given device Uid

## EXAMPLES

### EXAMPLE 1
```powershell
New-DattoRMMDeviceJob -DeviceUID 12345 -Data $JsonBody
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
Position: 1
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
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://celerium.github.io/Celerium.DattoRMM/site/Device/New-DattoRMMDeviceJob.html](https://celerium.github.io/Celerium.DattoRMM/site/Device/New-DattoRMMDeviceJob.html)

