---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteAlert.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMSiteAlert
---

# Get-DattoRMMSiteAlert

## SYNOPSIS
Fetches the alerts of the site identified by the given site Uid

## SYNTAX

```powershell
Get-DattoRMMSiteAlert [[-AlertType] <String>] [-SiteUID] <String> [-Muted] [[-Page] <Int32>] [[-Max] <Int32>]
 [-AllResults] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMSiteAlert cmdlet fetches the alerts of the site
identified by the given site Uid

By default only open alerts are returned

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMSiteAlert
```

Prompts for a site Uid and fetches data of the site

### EXAMPLE 2
```powershell
Get-DattoRMMSiteAlert -SiteUID '123456789'
```

Fetches data for the specific site Uid

### EXAMPLE 3
```powershell
Get-DattoRMMAccountAlert -SiteUID '123456789' -Page 2 -Max 5
```

Get the first defined number of items from the define page

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

### -SiteUID
Fetches data of the alert identified by the given site Id

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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteAlert.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteAlert.html)

