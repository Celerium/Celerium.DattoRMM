---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Test-DattoRMMAPIKey.html
parent: GET
schema: 2.0.0
title: Test-DattoRMMAPIKey
---

# Test-DattoRMMAPIKey

## SYNOPSIS
Test the DattoRMM API key

## SYNTAX

```powershell
Test-DattoRMMAPIKey [[-BaseUri] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Test-DattoRMMAPIKey cmdlet tests the base URI & API key that are defined
in the Add-DattoRMMBaseURI & Add-DattoRMMAPIKey cmdlets

Helpful when needing to validate general functionality or when using
RMM deployment tools

The DattoRMM status endpoint is called in this test

## EXAMPLES

### EXAMPLE 1
```powershell
Test-DattoRMMAPIKey
```

Tests the base URI & API key that are defined in the
Add-DattoRMMBaseURI & Add-DattoRMMAPIKey cmdlets

### EXAMPLE 2
```powershell
Test-DattoRMMAPIKey -BaseUri http://myapi.gateway.celerium.org
```

Tests the defined base URI & API key that was defined in
the Add-DattoRMMAPIKey cmdlet

The full base uri test path in this example is:
    http://myapi.gateway.celerium.org/regions

## PARAMETERS

### -BaseUri
Define the base URI for the DattoRMM API connection
using DattoRMM's URI or a custom URI

By default the value used is the one defined by the
Add-DattoRMMBaseURI function

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $DattoRMMModuleBaseUri
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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Test-DattoRMMAPIKey.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Test-DattoRMMAPIKey.html)

