---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Internal
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Internal/Request-DattoRMMAccessToken.html
parent: POST
schema: 2.0.0
title: Request-DattoRMMAccessToken
---

# Request-DattoRMMAccessToken

## SYNOPSIS
Requests an JWT access token using the users Api keys

## SYNTAX

```powershell
Request-DattoRMMAccessToken [[-ApiUri] <String>] [[-ApiKey] <String>] [[-ApiSecretKey] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Request-DattoRMMAccessToken cmdlet requests an JWT access token using
the users Api keys.
The JWT token is used to validate all API calls made to DattoRMM

## EXAMPLES

### EXAMPLE 1
```powershell
Request-DattoRMMAccessToken
```

Uses all the defined global variables to request an access token

### EXAMPLE 2
```powershell
Request-DattoRMMAccessToken -ApiUri 'https://gateway.celerium.org' -ApiKey '12345' -ApiSecretKey '12345'
```

Using the define values, sets, converts, & adds the values to global variables and requests an access token

### EXAMPLE 3
```
'Celerium@Celerium.org' | Request-DattoRMMAccessToken -ApiKey '12345' -ApiSecretKey '12345'
```

Using the define values, sets, converts, & adds the values to global variables and requests an access token

## PARAMETERS

### -ApiUri
Base URI for the DattoRMM Api connection

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $DattoRMMModuleBaseUri
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiKey
Plain text API key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $DattoRMMModuleApiKey
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ApiSecretKey
Plain text API secret key

If not defined the cmdlet will prompt you to enter the API secret key which
will be stored as a SecureString

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(Get-DattoRMMAPIKey -AsPlainText).ApiSecretKey
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

[https://celerium.github.io/Celerium.DattoRMM/site/Internal/Request-DattoRMMAccessToken.html](https://celerium.github.io/Celerium.DattoRMM/site/Internal/Request-DattoRMMAccessToken.html)

