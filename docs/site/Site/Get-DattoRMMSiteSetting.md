---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteSetting.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMSiteSetting
---

# Get-DattoRMMSiteSetting

## SYNOPSIS
Fetches settings of the site identified by the given site Uid

## SYNTAX

```powershell
Get-DattoRMMSiteSetting [-SiteUID] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMSiteSetting cmdlet fetches settings of the site
identified by the given site Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMSiteSetting
```

Prompts for a site Uid and fetches data of the site

### EXAMPLE 2
```powershell
Get-DattoRMMSiteSetting -SiteUID '123456789'
```

Fetches data for the specific site Id

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteSetting.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Get-DattoRMMSiteSetting.html)

