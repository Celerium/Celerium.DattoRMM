---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Site
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Site/New-DattoRMMSite.html
parent: PUT
schema: 2.0.0
title: New-DattoRMMSite
---

# New-DattoRMMSite

## SYNOPSIS
Creates a new site in the authenticated user's account

## SYNTAX

### CreateData (Default)
```powershell
New-DattoRMMSite -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Create
```powershell
New-DattoRMMSite -Name <String> [-Description <String>] [-Note <String>] [-OnDemand] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-DattoRMMSite cmdlet creates a new site in
the authenticated user's account

## EXAMPLES

### EXAMPLE 1
```powershell
New-DattoRMMSite -Name 'SiteName' -Description 'Example Site'
```

Create a new managed site account with the defined data

### EXAMPLE 2
```powershell
New-DattoRMMSite -Data $JsonBody
```

Create a new managed site account with with the structured JSON object

## PARAMETERS

### -Name
Name of the site

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

### -Description
Description of the site

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Note
Note for the site

```yaml
Type: String
Parameter Sets: Create
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnDemand
Is the site OnDemand

By default, if this switch is not specified, the site with be set to managed

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

[https://celerium.github.io/Celerium.DattoRMM/site/Site/New-DattoRMMSite.html](https://celerium.github.io/Celerium.DattoRMM/site/Site/New-DattoRMMSite.html)

