---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMModuleSettings.html
parent: DELETE
schema: 2.0.0
title: Remove-DattoRMMModuleSettings
---

# Remove-DattoRMMModuleSettings

## SYNOPSIS
Removes the stored DattoRMM configuration folder

## SYNTAX

```powershell
Remove-DattoRMMModuleSettings [[-DattoRMMConfigPath] <String>] [-AndVariables] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-DattoRMMModuleSettings cmdlet removes the DattoRMM folder and its files
This cmdlet also has the option to remove sensitive DattoRMM variables as well

By default configuration files are stored in the following location and will be removed:
    $env:USERPROFILE\Celerium.DattoRMM

## EXAMPLES

### EXAMPLE 1
```powershell
Remove-DattoRMMModuleSettings
```

Checks to see if the default configuration folder exists and removes it if it does

The default location of the DattoRMM configuration folder is:
    $env:USERPROFILE\Celerium.DattoRMM

### EXAMPLE 2
```powershell
Remove-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -AndVariables
```

Checks to see if the defined configuration folder exists and removes it if it does
If sensitive DattoRMM variables exist then they are removed as well

The location of the DattoRMM configuration folder in this example is:
    C:\Celerium.DattoRMM

## PARAMETERS

### -DattoRMMConfigPath
Define the location of the DattoRMM configuration folder

By default the configuration folder is located at:
    $env:USERPROFILE\Celerium.DattoRMM

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"Celerium.DattoRMM"}else{".Celerium.DattoRMM"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -AndVariables
Define if sensitive DattoRMM variables should be removed as well

By default the variables are not removed

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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMModuleSettings.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Remove-DattoRMMModuleSettings.html)

