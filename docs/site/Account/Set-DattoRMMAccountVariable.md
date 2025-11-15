---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Account
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Account/Set-DattoRMMAccountVariable.html
parent: POST
schema: 2.0.0
title: Set-DattoRMMAccountVariable
---

# Set-DattoRMMAccountVariable

## SYNOPSIS
Updates an account variable

## SYNTAX

### UpdateData (Default)
```powershell
Set-DattoRMMAccountVariable -VariableID <Int64> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-DattoRMMAccountVariable -VariableID <Int64> -Name <String> -Value <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-DattoRMMAccountVariable cmdlet updates an account variable

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoRMMAccountVariable -VariableID 12345 -Name 'VariableName' -Value 'VariableValue' -Masked
```

Updates the account variable with the defined data

### EXAMPLE 2
```powershell
Set-DattoRMMAccountVariable -Data $JsonBody
```

Updates the account variable with the structured JSON object

## PARAMETERS

### -VariableID
ID of the variable

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the variable

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value of the variable

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
JSON body

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-DattoRMMRequest function

```yaml
Type: Object
Parameter Sets: UpdateData
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

[https://celerium.github.io/Celerium.DattoRMM/site/Account/Set-DattoRMMAccountVariable.html](https://celerium.github.io/Celerium.DattoRMM/site/Account/Set-DattoRMMAccountVariable.html)

