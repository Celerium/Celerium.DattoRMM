---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Device
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Device/Move-DattoRMMDevice.html
parent: PUT
schema: 2.0.0
title: Move-DattoRMMDevice
---

# Move-DattoRMMDevice

## SYNOPSIS
Moves a device from one site to another site

## SYNTAX

```powershell
Move-DattoRMMDevice [-DeviceUID] <String> [-SiteUID] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Move-DattoRMMDevice cmdlet moves a device from
one site to another site

## EXAMPLES

### EXAMPLE 1
```powershell
Move-DattoRMMDevice -DeviceUID 12345 -SiteUID 6789
```

Moves a device from one site to another site

## PARAMETERS

### -DeviceUID
The UID of the device to move to a different site

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

### -SiteUID
The UID of the target site

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

[https://celerium.github.io/Celerium.DattoRMM/site/Device/Move-DattoRMMDevice.html](https://celerium.github.io/Celerium.DattoRMM/site/Device/Move-DattoRMMDevice.html)

