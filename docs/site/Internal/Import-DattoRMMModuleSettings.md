---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Import-DattoRMMModuleSettings.html
parent: GET
schema: 2.0.0
title: Import-DattoRMMModuleSettings
---

# Import-DattoRMMModuleSettings

## SYNOPSIS
Imports the DattoRMM BaseURI, API, & JSON configuration information to the current session

## SYNTAX

```powershell
Import-DattoRMMModuleSettings [[-DattoRMMConfigPath] <String>] [[-DattoRMMConfigFile] <String>]
 [-SkipRequestToken] [<CommonParameters>]
```

## DESCRIPTION
The Import-DattoRMMModuleSettings cmdlet imports the DattoRMM BaseURI, API, & JSON configuration
information stored in the DattoRMM configuration file to the users current session

By default the configuration file is stored in the following location:
    $env:USERPROFILE\Celerium.DattoRMM

## EXAMPLES

### EXAMPLE 1
```powershell
Import-DattoRMMModuleSettings
```

Validates that the configuration file created with the Export-DattoRMMModuleSettings cmdlet exists
then imports the stored data into the current users session

The default location of the DattoRMM configuration file is:
    $env:USERPROFILE\Celerium.DattoRMM\config.psd1

### EXAMPLE 2
```powershell
Import-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1
```

Validates that the configuration file created with the Export-DattoRMMModuleSettings cmdlet exists
then imports the stored data into the current users session

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

### -SkipRequestToken
Skips requesting an access token

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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Import-DattoRMMModuleSettings.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Import-DattoRMMModuleSettings.html)

