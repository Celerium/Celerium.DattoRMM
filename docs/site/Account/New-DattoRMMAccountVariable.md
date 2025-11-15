---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Account
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Account/New-DattoRMMAccountVariable.html
parent: PUT
schema: 2.0.0
title: New-DattoRMMAccountVariable
---

# New-DattoRMMAccountVariable

## SYNOPSIS
Creates an account variable

## SYNTAX

### CreateData (Default)
```powershell
New-DattoRMMAccountVariable -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Create
```powershell
New-DattoRMMAccountVariable -Name <String> -Value <String> [-Masked] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-DattoRMMAccountVariable cmdlet creates an account variable

## EXAMPLES

### EXAMPLE 1
```powershell
New-DattoRMMAccountVariable -Name 'VariableName' -Value 'VariableValue' -Masked
```

Create a new account variable with the defined data

### EXAMPLE 2
```powershell
New-DattoRMMAccountVariable -Data $JsonBody
```

Create a new account variable with the structured JSON object

## PARAMETERS

### -Name
Name of the variable

```yaml
Type: String
Parameter Sets: Create
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
Parameter Sets: Create
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Masked
Should the value of the variable be masked (hidden)

```yaml
Type: SwitchParameter
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
JSON body

Do NOT include the "Data" property in the JSON object as this is handled
by the Invoke-DattoRMMRequest function

```yaml
Type: Object
Parameter Sets: CreateData
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

[https://celerium.github.io/Celerium.DattoRMM/site/Account/New-DattoRMMAccountVariable.html](https://celerium.github.io/Celerium.DattoRMM/site/Account/New-DattoRMMAccountVariable.html)

