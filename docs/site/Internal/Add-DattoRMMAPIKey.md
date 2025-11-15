---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMAPIKey.html
parent: POST
schema: 2.0.0
title: Add-DattoRMMAPIKey
---

# Add-DattoRMMAPIKey

## SYNOPSIS
Sets your API key used to authenticate all API calls

## SYNTAX

### AsPlainText (Default)
```powershell
Add-DattoRMMAPIKey -ApiKey <String> [-ApiSecretKey <String>] [<CommonParameters>]
```

### SecureString
```powershell
Add-DattoRMMAPIKey -ApiKey <String> [-ApiKeySecureString <SecureString>] [<CommonParameters>]
```

## DESCRIPTION
The Add-DattoRMMAPIKey cmdlet sets your API key which is used to
authenticate all API calls made to DattoRMM

DattoRMM API keys can be generated via the DattoRMM web interface
    Setup \> Users \> {user} \> API

## EXAMPLES

### EXAMPLE 1
```powershell
Add-DattoRMMAPIKey -ApiKey '12345'
```

Prompts to enter in the API secret key which will be stored as a SecureString

### EXAMPLE 2
```powershell
Add-DattoRMMAPIKey -ApiKey '12345' -ApiSecretKey '12345'
```

Converts the string to a SecureString and stores it in the global variable

### EXAMPLE 3
```
'Celerium@Celerium.org' | Add-DattoRMMAPIKey -ApiKey '12345'
```

Converts the string to a SecureString and stores it in the global variable

## PARAMETERS

### -ApiKey
Plain text API key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiSecretKey
Plain text API secret key

If not defined the cmdlet will prompt you to enter the API secret key which
will be stored as a SecureString

```yaml
Type: String
Parameter Sets: AsPlainText
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiKeySecureString
Input a SecureString object containing the API key

```yaml
Type: SecureString
Parameter Sets: SecureString
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMAPIKey.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Add-DattoRMMAPIKey.html)

