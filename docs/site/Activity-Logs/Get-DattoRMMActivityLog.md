---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Activity-Logs
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Activity-Logs/Get-DattoRMMActivityLog.html
parent: GET
schema: 2.0.0
title: Get-DattoRMMActivityLog
---

# Get-DattoRMMActivityLog

## SYNOPSIS
Fetches the activity logs

## SYNTAX

```powershell
Get-DattoRMMActivityLog [[-Order] <String>] [[-SearchAfter] <String>] [[-From] <DateTime>]
 [[-Until] <DateTime>] [[-Entities] <String[]>] [[-Categories] <String[]>] [[-Actions] <String[]>]
 [[-SiteIDs] <String[]>] [[-UserIDs] <String[]>] [[-Page] <String>] [[-Size] <Int32>] [-AllResults]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoRMMActivityLog cmdlet fetches the activity logs

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoRMMActivityLog
```

Returns logs from last 15 minutes

### EXAMPLE 2
```powershell
Get-DattoRMMActivityLog -From (Get-Date).AddHours(-1)
```

Returns logs from last hour

### EXAMPLE 3
```powershell
Get-DattoRMMActivityLog -Size 100 -AllResults
```

Gets all activity logs, 100 at a time

## PARAMETERS

### -Order
Specifies the order in which records should be returned
based on their creation date

Allowed Values:
    asc
    desc

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchAfter
Acts as a pointer to determine the starting point for returning
records from the database

It is not advised to set this parameter manually
Instead, it is recommended to utilize the 'prevPage' and 'nextPage' URLs that
are returned in the response where this parameter in already included

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From
Defines the UTC start date for fetching data

By default API returns logs from last 15 minutes

Format: yyyy-MM-ddTHH:mm:ssZ

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Until
Defines the UTC end date for fetching data

Format: yyyy-MM-ddTHH:mm:ssZ

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Entities
Filters the returned activity logs based on their type

Allowed Values:
    device
    user

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Categories
Filters the returned activity logs based on their category

Example Values:
    job
    device

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Actions
Filters the returned activity logs based on their action

Example Values:
    deployment
    note

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SiteIDs
Filters the returned activity logs based on the site they were created in

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserIDs
Filters the returned activity logs based on the user they are associated with

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
Return items starting from the defined page set

Allowed Values:
    next
    previous

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
Return the first N items

Allowed Value: 1-250

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllResults
Returns all items from an endpoint

Highly recommended to only use with filters to reduce API errors\timeouts

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

[https://celerium.github.io/Celerium.DattoRMM/site/Activity-Logs/Get-DattoRMMActivityLog.html](https://celerium.github.io/Celerium.DattoRMM/site/Activity-Logs/Get-DattoRMMActivityLog.html)

