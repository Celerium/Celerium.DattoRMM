---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteVariable.html
parent: DELETE
schema: 2.0.0
title: Remove-DattoRMMSiteVariable
---

# Remove-DattoRMMSiteVariable

## SYNOPSIS
Deletes the site variable identified by the given site Uid and variable Id

## SYNTAX

```powershell
Remove-DattoRMMSiteVariable [-SiteUID] <String> [-VariableID] <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-DattoRMMSiteVariable cmdlet deletes the site variable
identified by the given site Uid and variable Id

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-DattoRMMSiteVariable -SiteUID 12345 -VariableID 12345
```

Deletes the site variable identified by the given site Uid and variable Id

## PARAMETERS

### -SiteUID
UID of the site

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

### -VariableID
ID of the variable

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteVariable.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteVariable.html)

