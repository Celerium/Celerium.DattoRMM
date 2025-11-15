---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteProxy.html
parent: DELETE
schema: 2.0.0
title: Remove-DattoRMMSiteProxy
---

# Remove-DattoRMMSiteProxy

## SYNOPSIS
Deletes site proxy settings for the site identified by the given site Uid

## SYNTAX

```powershell
Remove-DattoRMMSiteProxy [-SiteUID] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-DattoRMMSiteProxy cmdlet deletes site proxy settings
for the site identified by the given site Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-DattoRMMSiteProxy -SiteUID 12345
```

Deletes the site proxy settings with the defined Id

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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteProxy.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Remove-DattoRMMSiteProxy.html)

