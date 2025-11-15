---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteVariable.html
parent: POST
schema: 2.0.0
title: Set-DattoRMMSiteVariable
---

# Set-DattoRMMSiteVariable

## SYNOPSIS
Updates the site variable identified by the given
site Uid and variable Id

## SYNTAX

### UpdateData (Default)
```powershell
Set-DattoRMMSiteVariable -SiteUID <String> -VariableID <Int64> -Data <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Update
```powershell
Set-DattoRMMSiteVariable -SiteUID <String> -VariableID <Int64> -Name <String> -Value <String> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-DattoRMMSiteVariable cmdlet updates the site variable
identified by the given site Uid and variable Id

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoRMMSiteVariable -SiteUID 12345 -VariableID 12345 -Name 'NewVariableName' -Value 'NewVariableValue'
```

Updates the site variable with the defined data

### EXAMPLE 2
```powershell
Set-DattoRMMSiteVariable -Data $JsonBody
```

Updates the site variable with the structured JSON object

## PARAMETERS

### -SiteUID
UID of the site

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteVariable.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteVariable.html)

