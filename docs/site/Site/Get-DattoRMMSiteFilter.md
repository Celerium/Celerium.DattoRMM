---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteFilter.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMSiteFilter
---

# Get-DattoRMMSiteFilter

## SYNOPSIS
Fetches the site device filters (that the user can see with administrator role)
of the site identified by the given site Uid

## SYNTAX

```powershell
Get-DattoRMMSiteFilter [-SiteUID] <String> [[-Page] <Int32>] [[-Max] <Int32>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMSiteFilter cmdlet fetches the site device filters
(that the user can see with administrator role) of the site identified
by the given site Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMSiteFilter
```

Prompts for a site Uid and fetches data of the site

### EXAMPLE 2
```powershell
Get-DattoRMMSiteFilter -SiteUID '123456789'
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
Position: 1
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
Position: 2
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
Position: 3
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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteFilter.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteFilter.html)

