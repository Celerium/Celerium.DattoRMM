---
external help file: Celerium.DattoRMM-help.xml
grand_parent: Device
Module Name: Celerium.DattoRMM
online version: https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceUDF.html
parent: POST
schema: 2.0.0
title: Set-DattoRMMDeviceUDF
---

# Set-DattoRMMDeviceUDF

## SYNOPSIS
Sets the user defined fields of a device identified by
the given device Uid

## SYNTAX

### UpdateData (Default)
```powershell
Set-DattoRMMDeviceUDF -DeviceUID <String> -Data <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Update
```powershell
Set-DattoRMMDeviceUDF -DeviceUID <String> [-WhatIf] [-Confirm] [-udf1 <String[]>] [-udf2 <String[]>]
 [-udf3 <String[]>] [-udf4 <String[]>] [-udf5 <String[]>] [-udf6 <String[]>] [-udf7 <String[]>]
 [-udf8 <String[]>] [-udf9 <String[]>] [-udf10 <String[]>] [-udf11 <String[]>] [-udf12 <String[]>]
 [-udf13 <String[]>] [-udf14 <String[]>] [-udf15 <String[]>] [-udf16 <String[]>] [-udf17 <String[]>]
 [-udf18 <String[]>] [-udf19 <String[]>] [-udf20 <String[]>] [-udf21 <String[]>] [-udf22 <String[]>]
 [-udf23 <String[]>] [-udf24 <String[]>] [-udf25 <String[]>] [-udf26 <String[]>] [-udf27 <String[]>]
 [-udf28 <String[]>] [-udf29 <String[]>] [-udf30 <String[]>] [-udf31 <String[]>] [-udf32 <String[]>]
 [-udf33 <String[]>] [-udf34 <String[]>] [-udf35 <String[]>] [-udf36 <String[]>] [-udf37 <String[]>]
 [-udf38 <String[]>] [-udf39 <String[]>] [-udf40 <String[]>] [-udf41 <String[]>] [-udf42 <String[]>]
 [-udf43 <String[]>] [-udf44 <String[]>] [-udf45 <String[]>] [-udf46 <String[]>] [-udf47 <String[]>]
 [-udf48 <String[]>] [-udf49 <String[]>] [-udf50 <String[]>] [-udf51 <String[]>] [-udf52 <String[]>]
 [-udf53 <String[]>] [-udf54 <String[]>] [-udf55 <String[]>] [-udf56 <String[]>] [-udf57 <String[]>]
 [-udf58 <String[]>] [-udf59 <String[]>] [-udf60 <String[]>] [-udf61 <String[]>] [-udf62 <String[]>]
 [-udf63 <String[]>] [-udf64 <String[]>] [-udf65 <String[]>] [-udf66 <String[]>] [-udf67 <String[]>]
 [-udf68 <String[]>] [-udf69 <String[]>] [-udf70 <String[]>] [-udf71 <String[]>] [-udf72 <String[]>]
 [-udf73 <String[]>] [-udf74 <String[]>] [-udf75 <String[]>] [-udf76 <String[]>] [-udf77 <String[]>]
 [-udf78 <String[]>] [-udf79 <String[]>] [-udf80 <String[]>] [-udf81 <String[]>] [-udf82 <String[]>]
 [-udf83 <String[]>] [-udf84 <String[]>] [-udf85 <String[]>] [-udf86 <String[]>] [-udf87 <String[]>]
 [-udf88 <String[]>] [-udf89 <String[]>] [-udf90 <String[]>] [-udf91 <String[]>] [-udf92 <String[]>]
 [-udf93 <String[]>] [-udf94 <String[]>] [-udf95 <String[]>] [-udf96 <String[]>] [-udf97 <String[]>]
 [-udf98 <String[]>] [-udf99 <String[]>] [-udf100 <String[]>] [<CommonParameters>]
```

## DESCRIPTION
The Set-DattoRMMDeviceUDF cmdlet sets the user defined fields
of a device identified by the given device Uid

Any user defined field supplied with an empty value will be set to null
All user defined fields not supplied will retain their current values

DYNAMIC PARAMETERS
-udf1 to -udf100 are created dynamically and will NOT appear in Get-Help

Accepts string & null/empty values

SYNTAX
Set-DattoRMMDeviceUDF -DeviceUID \<String\> -udf1..100 \<String\> \[-WhatIf\] \[-Confirm\] \[\<CommonParameters\>\]

## EXAMPLES

### EXAMPLE 1
```powershell
Set-DattoRMMDeviceUDF -DeviceUID 12345 -udf1 'Custom Value' -udf2 $null
```

These are dynamically created parameters and will not appear in Get-Help

Set the defined devices UDF's with the defined values

### EXAMPLE 2
```powershell
Set-DattoRMMDeviceUDF -DeviceUID 12345 -Data $JsonBody
```

Set the defined devices UDF's with the structured JSON object

## PARAMETERS

### -DeviceUID
The UID of the device to create the quick job on

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

### -udf1
{{ Fill udf1 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf10
{{ Fill udf10 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf100
{{ Fill udf100 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf11
{{ Fill udf11 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf12
{{ Fill udf12 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf13
{{ Fill udf13 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf14
{{ Fill udf14 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf15
{{ Fill udf15 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf16
{{ Fill udf16 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf17
{{ Fill udf17 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf18
{{ Fill udf18 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf19
{{ Fill udf19 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf2
{{ Fill udf2 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf20
{{ Fill udf20 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf21
{{ Fill udf21 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf22
{{ Fill udf22 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf23
{{ Fill udf23 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf24
{{ Fill udf24 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf25
{{ Fill udf25 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf26
{{ Fill udf26 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf27
{{ Fill udf27 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf28
{{ Fill udf28 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf29
{{ Fill udf29 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf3
{{ Fill udf3 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf30
{{ Fill udf30 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf31
{{ Fill udf31 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf32
{{ Fill udf32 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf33
{{ Fill udf33 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf34
{{ Fill udf34 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf35
{{ Fill udf35 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf36
{{ Fill udf36 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf37
{{ Fill udf37 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf38
{{ Fill udf38 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf39
{{ Fill udf39 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf4
{{ Fill udf4 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf40
{{ Fill udf40 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf41
{{ Fill udf41 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf42
{{ Fill udf42 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf43
{{ Fill udf43 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf44
{{ Fill udf44 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf45
{{ Fill udf45 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf46
{{ Fill udf46 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf47
{{ Fill udf47 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf48
{{ Fill udf48 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf49
{{ Fill udf49 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf5
{{ Fill udf5 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf50
{{ Fill udf50 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf51
{{ Fill udf51 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf52
{{ Fill udf52 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf53
{{ Fill udf53 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf54
{{ Fill udf54 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf55
{{ Fill udf55 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf56
{{ Fill udf56 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf57
{{ Fill udf57 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf58
{{ Fill udf58 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf59
{{ Fill udf59 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf6
{{ Fill udf6 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf60
{{ Fill udf60 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf61
{{ Fill udf61 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf62
{{ Fill udf62 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf63
{{ Fill udf63 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf64
{{ Fill udf64 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf65
{{ Fill udf65 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf66
{{ Fill udf66 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf67
{{ Fill udf67 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf68
{{ Fill udf68 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf69
{{ Fill udf69 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf7
{{ Fill udf7 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf70
{{ Fill udf70 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf71
{{ Fill udf71 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf72
{{ Fill udf72 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf73
{{ Fill udf73 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf74
{{ Fill udf74 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf75
{{ Fill udf75 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf76
{{ Fill udf76 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf77
{{ Fill udf77 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf78
{{ Fill udf78 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf79
{{ Fill udf79 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf8
{{ Fill udf8 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf80
{{ Fill udf80 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf81
{{ Fill udf81 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf82
{{ Fill udf82 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf83
{{ Fill udf83 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf84
{{ Fill udf84 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf85
{{ Fill udf85 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf86
{{ Fill udf86 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf87
{{ Fill udf87 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf88
{{ Fill udf88 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf89
{{ Fill udf89 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf9
{{ Fill udf9 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf90
{{ Fill udf90 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf91
{{ Fill udf91 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf92
{{ Fill udf92 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf93
{{ Fill udf93 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf94
{{ Fill udf94 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf95
{{ Fill udf95 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf96
{{ Fill udf96 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf97
{{ Fill udf97 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf98
{{ Fill udf98 Description }}

```yaml
Type: String[]
Parameter Sets: Update
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -udf99
{{ Fill udf99 Description }}

```yaml
Type: String[]
Parameter Sets: Update
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

[https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceUDF.html](https://celerium.github.io/Celerium.DattoRMM/site/Device/Set-DattoRMMDeviceUDF.html)

