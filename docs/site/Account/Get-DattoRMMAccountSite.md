---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Account
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountSite.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMAccountSite
---

# Get-DattoRMMAccountSite

## SYNOPSIS
Fetches the site records of the authenticated user's account

## SYNTAX

```powershell
Get-DattoRMMAccountSite [[-SiteName] <String>] [[-Page] <Int32>] [[-Max] <Int32>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMAccountSite cmdlet fetches the site records
of the authenticated user's account

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMAccountSite
```

Gets the first 250 account sites

### EXAMPLE 2
```powershell
Get-DattoRMMAccountSite -Page 2 -Max 5
```

Get the first defined number of items from the define page

## PARAMETERS

### -SiteName
Filters results based on the provided value using the LIKE operator

Partial matches are allowed

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

[https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountSite.html](https://celerium.github.io/Celerium.DattoRMM/site/Account/Get-DattoRMMAccountSite.html)

