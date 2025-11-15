---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/ConvertTo-DattoRMMQueryString.html
parent: PUT
schema: 2.0.0
title: ConvertTo-DattoRMMQueryString
---

# ConvertTo-DattoRMMQueryString

## SYNOPSIS
Converts uri filter parameters

## SYNTAX

```powershell
ConvertTo-DattoRMMQueryString [[-UriFilter] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
The ConvertTo-DattoRMMQueryString cmdlet converts & formats uri query parameters
from a function which are later used to make the full resource uri for
an API call

This is an internal helper function the ties in directly with the
ConvertTo-DattoRMMQueryString & any public functions that define parameters

## EXAMPLES

### EXAMPLE 1
```powershell
ConvertTo-DattoRMMQueryString -UriFilter $HashTable
```

Example HashTable:
    $UriParameters = @{
        'filter\[id\]'\]               = 123456789
        'filter\[organization_id\]'\]  = 12345
    }

## PARAMETERS

### -UriFilter
Hashtable of values to combine a functions parameters with
the ResourceUri parameter

This allows for the full uri query to occur

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/ConvertTo-DattoRMMQueryString.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/ConvertTo-DattoRMMQueryString.html)

