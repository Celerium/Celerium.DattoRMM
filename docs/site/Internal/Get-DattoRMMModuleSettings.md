---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMModuleSettings
---

# Get-DattoRMMModuleSettings

## SYNOPSIS
Gets the saved DattoRMM configuration settings

## SYNTAX

```powershell
Get-DattoRMMModuleSettings [[-DattoRMMConfigPath] <String>] [[-DattoRMMConfigFile] <String>] [-OpenConfigFile]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMModuleSettings cmdlet gets the saved DattoRMM configuration settings
from the local system

By default the configuration file is stored in the following location:
    $env:USERPROFILE\Celerium.DattoRMM

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-DattoRMMModuleSettings

The default location of the DattoRMM configuration file is:
    $env:USERPROFILE\Celerium.DattoRMM\config.psd1

### EXAMPLE 2
```powershell
Get-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the DattoRMM configuration file in this example is:
    C:\Celerium.DattoRMM\MyConfig.psd1

## PARAMETERS

### -DattoRMMConfigPath
Define the location to store the DattoRMM configuration file

By default the configuration file is stored in the following location:
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

### -DattoRMMConfigFile
Define the name of the DattoRMM configuration file

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenConfigFile
Opens the DattoRMM configuration file

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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMModuleSettings.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Get-DattoRMMModuleSettings.html)

