---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMBaseURI.html
parent: POST
schema: 2.0.0
title: Add-DattoRMMBaseURI
---

# Add-DattoRMMBaseURI

## SYNOPSIS
Sets the base URI for the DattoRMM API connection

## SYNTAX

### PreDefinedUri (Default)
```powershell
Add-DattoRMMBaseURI [-BaseApiUri <String>] -DataCenter <String> [<CommonParameters>]
```

### CustomUri
```powershell
Add-DattoRMMBaseURI -BaseUri <String> [-BaseApiUri <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-DattoRMMBaseURI cmdlet sets the base URI which is used
to construct the full URI for all API calls

## EXAMPLES

### EXAMPLE 1
```powershell
Add-DattoRMMBaseURI
```

You will be prompted to select a data center

### EXAMPLE 2
```powershell
Add-DattoRMMBaseURI -BaseUri 'https://gateway.celerium.org'
```

The base URI will use https://gateway.celerium.org

### EXAMPLE 3
```
'https://gateway.celerium.org' | Add-DattoRMMBaseURI
```

The base URI will use https://gateway.celerium.org

### EXAMPLE 4
```powershell
Add-DattoRMMBaseURI -DataCenter Pinotage
```

The base URI will use https://pinotage-api.centrastage.net

## PARAMETERS

### -BaseUri
Sets the base URI for the DattoRMM API connection.
Helpful
if using a custom API gateway

```yaml
Type: String
Parameter Sets: CustomUri
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -BaseApiUri
Sets the base Api URI for the DattoRMM API connection

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: /api/v2
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataCenter
Defines the data center (platform) to use which in turn defines which
base API URL is used

Allowed values:
'Pinotage', 'Merlot', 'Concord', 'Vidal', 'Zinfandel', 'Syrah'

    'Pinotage'  = 'https://pinotage-api.centrastage.net'
    'Merlot'    = 'https://merlot-api.centrastage.net'
    'Concord'   = 'https://concord-api.centrastage.net'
    'Vidal'     = 'https://vidal-api.centrastage.net'
    'Zinfandel' = 'https://zinfandel-api.centrastage.net'
    'Syrah'     = 'https://syrah-api.centrastage.net'

```yaml
Type: String
Parameter Sets: PreDefinedUri
Aliases: Platform

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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMBaseURI.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMBaseURI.html)

