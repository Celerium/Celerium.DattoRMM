---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Alert
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Alert/Set-DattoRMMAlert.html
parent: POST
schema: 2.0.0
title: Set-DattoRMMAlert
---

# Set-DattoRMMAlert

## SYNOPSIS
Updates (resolves) an alert

## SYNTAX

```powershell
Set-DattoRMMAlert [-AlertUID] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-DattoRMMAlert cmdlet updates (resolves) an alert

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoRMMAlert -AlertUID 12345
```

Updates (resolves) the alert with the defined Uid

## PARAMETERS

### -AlertUID
UID of the alert

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

[https://celerium.github.io/Celerium.DattoRMM/site/Alert/Set-DattoRMMAlert.html](https://celerium.github.io/Celerium.DattoRMM/site/Alert/Set-DattoRMMAlert.html)

