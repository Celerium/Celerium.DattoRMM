---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Filter
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Filter/Get-DattoRMMFilter.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMFilter
---

# Get-DattoRMMFilter

## SYNOPSIS
Gets both default & custom filters

## SYNTAX

```powershell
Get-DattoRMMFilter [[-FilterType] <String>] [[-Page] <Int32>] [[-Max] <Int32>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMFilter cmdlet gets both default & custom filters

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMFilter
```

Gets the first 250 default filters

### EXAMPLE 2
```powershell
Get-DattoRMMFilter -FilterType All
```

Gets the first 250 filters of all types

### EXAMPLE 3
```powershell
Get-DattoRMMFilter -Page 2 -Max 5
```

Get the first defined number of items from the define page

## PARAMETERS

### -FilterType
Define the type of filter to return

Allowed Values:
    All
    Default
    Custom

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
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

[https://celerium.github.io/Celerium.DattoRMM/site/Filter/Get-DattoRMMFilter.html](https://celerium.github.io/Celerium.DattoRMM/site/Filter/Get-DattoRMMFilter.html)

