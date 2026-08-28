---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Device
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevicePatch.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMDevicePatch
---

# Get-DattoRMMDevicePatch

## SYNOPSIS
Gets patch data of the device identified by the given device Uid

## SYNTAX

```powershell
Get-DattoRMMDevicePatch [-DeviceUID] <String> [[-InstallStatus] <String>] [[-Page] <Int32>] [[-Max] <Int32>]
 [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMDevicePatch cmdlet gets patch data of the device
identified by the given device Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMDevicePatch -DeviceUID 123456789
```

Gets all patch data for the device identified by the given device Uid

### EXAMPLE 2
```powershell
Get-DattoRMMDevicePatch -DeviceUID 123456789 -InstallStatus INSTALLED -Page 2 -Max 5
```

Gets the first defined number of items from the defined page for installed patches

## PARAMETERS

### -DeviceUID
Gets data of the device identified by the given device Uid

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

### -InstallStatus
Show patches with the given install status

Allowed Values:
    'INSTALLED', 'APPROVED_PENDING', 'NOT_APPROVED'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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

[https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevicePatch.html](https://celerium.github.io/Celerium.DattoRMM/site/Device/Get-DattoRMMDevicePatch.html)

[https://zinfandel-api.centrastage.net/api/swagger-ui/index.html](https://zinfandel-api.centrastage.net/api/swagger-ui/index.html)

