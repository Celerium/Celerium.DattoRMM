---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteDevice.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMSiteDevice
---

# Get-DattoRMMSiteDevice

## SYNOPSIS
Fetches the devices records of the site identified by the given site Uid

## SYNTAX

### DeviceOnly (Default)
```powershell
Get-DattoRMMSiteDevice -SiteUID <String> [-FilterID <String>] [-Page <Int32>] [-Max <Int32>] [-AllResults]
 [<CommonParameters>]
```

### DeviceNetworkInterface
```powershell
Get-DattoRMMSiteDevice -SiteUID <String> [-NetworkInterface] [-Page <Int32>] [-Max <Int32>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMSiteDevice cmdlet fetches the devices records of the
site identified by the given site Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMSiteDevice
```

Prompts for a site Uid and fetches data of the site

### EXAMPLE 2
```powershell
Get-DattoRMMSiteDevice -SiteUID '123456789'
```

Fetches data for the specific site Id

### EXAMPLE 3
```powershell
Get-DattoRMMAccountAlert -SiteUID '123456789' -Page 2 -Max 5
```

Get the first defined number of items from the define page

## PARAMETERS

### -SiteUID
Fetches data of a specific site identified by the given site Uid

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

### -FilterID
Fetches data of a specific site device identified by the given device Id

```yaml
Type: String
Parameter Sets: DeviceOnly
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkInterface
Fetches the shortened devices records with network interface information
of the site identified by the given site Uid

```yaml
Type: SwitchParameter
Parameter Sets: DeviceNetworkInterface
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
Parameter Sets: (All)
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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteDevice.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteDevice.html)

