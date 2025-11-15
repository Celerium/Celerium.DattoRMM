---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMAPIKey.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMAPIKey
---

# Get-DattoRMMAPIKey

## SYNOPSIS
Gets the DattoRMM API key

## SYNTAX

```powershell
Get-DattoRMMAPIKey [-AsPlainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMAPIKey cmdlet gets the DattoRMM API key from
the global variable and returns it as an object

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMAPIKey
```

Gets the Api & Api secret key and returns them as an object.
The
API secret key is returned as a secure string

### EXAMPLE 2
```powershell
Get-DattoRMMAPIKey -AsPlainText
```

Gets the Api & Api secret key and returns them as an object.
The
API secret key is returned as plain text

## PARAMETERS

### -AsPlainText
Decrypt and return the API key in plain text

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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMAPIKey.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMAPIKey.html)

