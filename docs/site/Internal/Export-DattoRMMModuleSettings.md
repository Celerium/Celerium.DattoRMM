---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Export-DattoRMMModuleSettings.html
parent: PATCH
schema: 2.0.0
title: Export-DattoRMMModuleSettings
---

# Export-DattoRMMModuleSettings

## SYNOPSIS
Exports the DattoRMM BaseURI, API, & JSON configuration information to file

## SYNTAX

```powershell
Export-DattoRMMModuleSettings [[-DattoRMMConfigPath] <String>] [[-DattoRMMConfigFile] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Export-DattoRMMModuleSettings cmdlet exports the DattoRMM BaseURI, API, & JSON configuration information to file

Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
This means that you cannot copy your configuration file to another computer or user account and expect it to work

## EXAMPLES

### EXAMPLE 1
```powershell
Export-DattoRMMModuleSettings
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's DattoRMM configuration file located at:
    $env:USERPROFILE\Celerium.DattoRMM\config.psd1

### EXAMPLE 2
```powershell
Export-DattoRMMModuleSettings -DattoRMMConfigPath C:\Celerium.DattoRMM -DattoRMMConfigFile MyConfig.psd1
```

Validates that the BaseURI, API, and JSON depth are set then exports their values
to the current user's DattoRMM configuration file located at:
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Export-DattoRMMModuleSettings.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Export-DattoRMMModuleSettings.html)

