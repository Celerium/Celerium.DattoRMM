---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteProxy.html
parent: POST
schema: 2.0.0
title: Set-DattoRMMSiteProxy
---

# Set-DattoRMMSiteProxy

## SYNOPSIS
Creates/updates the proxy settings for the site identified
by the given site Uid

## SYNTAX

### UpdateData (Default)
```powershell
Set-DattoRMMSiteProxy -SiteUID <String> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-DattoRMMSiteProxy -SiteUID <String> -Type <String> [-ProxyHost <String>] [-Port <Int32>]
 [-UserName <String>] [-Password <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-DattoRMMSiteProxy cmdlet creates/updates the proxy settings
for the site identified by the given site Uid

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoRMMSiteProxy -SiteUID 12345 -Host proxy.celerium.org -UserName 'Celerium' -Password 'Password' -Port 8080 -Type socks5
```

Updates/creates the site proxy settings with the defined data

### EXAMPLE 2
```powershell
Set-DattoRMMSiteProxy -Data $JsonBody
```

Updates/creates the site proxy settings with the structured JSON object

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

### -Type
Proxy type, this is case sensitive

Allowed values:
    http
    socks4
    socks5

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

### -ProxyHost
Proxy host address

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Proxy port

```yaml
Type: Int32
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
Proxy username

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
Proxy password

```yaml
Type: String
Parameter Sets: Update
Aliases:

Required: False
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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteProxy.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/Set-DattoRMMSiteProxy.html)

