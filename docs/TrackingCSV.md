---
title: Tracking CSV
parent: Home
nav_order: 2
---

# Tracking CSV

When updating the documentation for this project, the tracking CSV plays a huge part in organizing of the markdown documents. Any new functions or endpoints should be added to the tracking CSV when publishing an updated module or documentation version.

{: .warning }
I recommend downloading the CSV from the link provided rather then viewing the table below.

[Tracking CSV](https://github.com/Celerium/Celerium.DattoRMM/blob/master/docs/endpoints.csv)

---

## CSV markdown table

|Category     |EndpointUri                                 |Method|Function                          |
|-------------|--------------------------------------------|------|----------------------------------|
|Account      |/v2/account/variable                        |PUT   |New-DattoRMMAccountVariable       |
|Account      |/v2/account/variable/{variableId}           |POST  |Set-DattoRMMAccountVariable       |
|Account      |/v2/account/variable/{variableId}           |DELETE|Remove-DattoRMMAccountVariable    |
|Account      |/v2/account                                 |GET   |Get-DattoRMMAccount               |
|Account      |/v2/account/variables                       |GET   |Get-DattoRMMAccountVariable       |
|Account      |/v2/account/users                           |GET   |Get-DattoRMMAccountUser           |
|Account      |/v2/account/sites                           |GET   |Get-DattoRMMAccountSite           |
|Account      |/v2/account/dnet-site-mappings              |GET   |Get-DattoRMMAccountDnetSiteMapping|
|Account      |/v2/account/devices                         |GET   |Get-DattoRMMAccountDevice         |
|Account      |/v2/account/components                      |GET   |Get-DattoRMMAccountComponent      |
|Account      |/v2/account/alerts/resolved                 |GET   |Get-DattoRMMAccountAlert          |
|Account      |/v2/account/alerts/open                     |GET   |Get-DattoRMMAccountAlert          |
|Activity-Logs|/v2/activity-logs                           |GET   |Get-DattoRMMActivityLog           |
|Alert        |/v2/alert/{alertUid}/resolve                |POST  |Set-DattoRMMAlert                 |
|Audit        |/v2/alert/{alertUid}                        |GET   |Get-DattoRMMAlert                 |
|Audit        |/v2/audit/printer/{deviceUid}               |GET   |Get-DattoRMMAuditPrinter          |
|Audit        |/v2/audit/esxihost/{deviceUid}              |GET   |Get-DattoRMMAuditESXI             |
|Audit        |/v2/audit/device/{deviceUid}                |GET   |Get-DattoRMMAuditDevice           |
|Audit        |/v2/audit/device/{deviceUid}/software       |GET   |Get-DattoRMMAuditDevice           |
|Audit        |/v2/audit/device/macAddress/{macAddress}    |GET   |Get-DattoRMMAuditDevice           |
|Device       |/v2/device/{deviceUid}/site/{siteUid}       |PUT   |Move-DattoRMMDevice               |
|Device       |/v2/device/{deviceUid}/quickjob             |PUT   |New-DattoRMMDeviceJob             |
|Device       |/v2/device/{deviceUid}/warranty             |POST  |Set-DattoRMMDeviceWarranty        |
|Device       |/v2/device/{deviceUid}/udf                  |POST  |Set-DattoRMMDeviceUDF             |
|Device       |/v2/device/{deviceUid}                      |GET   |Get-DattoRMMDevice                |
|Device       |/v2/device/{deviceUid}/alerts/resolved      |GET   |Get-DattoRMMDeviceAlert           |
|Device       |/v2/device/{deviceUid}/alerts/open          |GET   |Get-DattoRMMDeviceAlert           |
|Device       |/v2/device/macAddress/{macAddress}          |GET   |Get-DattoRMMDevice                |
|Device       |/v2/device/id/{deviceId}                    |GET   |Get-DattoRMMDevice                |
|Filter       |/v2/filter/default-filters                  |GET   |Get-DattoRMMFilter                |
|Filter       |/v2/filter/custom-filters                   |GET   |Get-DattoRMMFilter                |
|Internal     |                                            |POST  |Add-DattoRMMAPIKey                |
|Internal     |                                            |POST  |Request-DattoRMMAccessToken       |
|Internal     |                                            |POST  |Add-DattoRMMBaseURI               |
|Internal     |                                            |PUT   |ConvertTo-DattoRMMQueryString     |
|Internal     |                                            |PATCH |Export-DattoRMMModuleSettings     |
|Internal     |                                            |GET   |Get-DattoRMMAccessToken           |
|Internal     |                                            |GET   |Get-DattoRMMAPIKey                |
|Internal     |                                            |GET   |Get-DattoRMMBaseURI               |
|Internal     |                                            |GET   |Get-DattoRMMModuleSettings        |
|Internal     |                                            |GET   |Import-DattoRMMModuleSettings     |
|Internal     |                                            |GET   |Invoke-DattoRMMRequest            |
|Internal     |                                            |DELETE|Remove-DattoRMMAPIKey             |
|Internal     |                                            |DELETE|Remove-DattoRMMBaseURI            |
|Internal     |                                            |DELETE|Remove-DattoRMMModuleSettings     |
|Internal     |                                            |GET   |Test-DattoRMMAPIKey               |
|Job          |/v2/job/{jobUid}                            |GET   |Get-DattoRMMJob                   |
|Job          |/v2/job/{jobUid}/results/{deviceUid}        |GET   |Get-DattoRMMJobResult             |
|Job          |/v2/job/{jobUid}/results/{deviceUid}/stdout |GET   |Get-DattoRMMJobResult             |
|Job          |/v2/job/{jobUid}/results/{deviceUid}/stderr |GET   |Get-DattoRMMJobResult             |
|Job          |/v2/job/{jobUid}/components                 |GET   |Get-DattoRMMJob                   |
|Site         |/v2/site                                    |PUT   |New-DattoRMMSite                  |
|Site         |/v2/site/{siteUid}/variable                 |PUT   |New-DattoRMMSiteVariable          |
|Site         |/v2/site/{siteUid}                          |GET   |Get-DattoRMMSite                  |
|Site         |/v2/site/{siteUid}                          |POST  |Set-DattoRMMSite                  |
|Site         |/v2/site/{siteUid}/variable/{variableId}    |POST  |Set-DattoRMMSiteVariable          |
|Site         |/v2/site/{siteUid}/variable/{variableId}    |DELETE|Remove-DattoRMMSiteVariable       |
|Site         |/v2/site/{siteUid}/settings/proxy           |POST  |Set-DattoRMMSiteProxy             |
|Site         |/v2/site/{siteUid}/settings/proxy           |DELETE|Remove-DattoRMMSiteProxy          |
|Site         |/v2/site/{siteUid}/variables                |GET   |Get-DattoRMMSiteVariable          |
|Site         |/v2/site/{siteUid}/settings                 |GET   |Get-DattoRMMSiteSetting           |
|Site         |/v2/site/{siteUid}/filters                  |GET   |Get-DattoRMMSiteFilter            |
|Site         |/v2/site/{siteUid}/devices                  |GET   |Get-DattoRMMSiteDevice            |
|Site         |/v2/site/{siteUid}/devices/network-interface|GET   |Get-DattoRMMSiteDevice            |
|Site         |/v2/site/{siteUid}/alerts/resolved          |GET   |Get-DattoRMMSiteAlert             |
|Site         |/v2/site/{siteUid}/alerts/open              |GET   |Get-DattoRMMSiteAlert             |
|System       |/v2/system/status                           |GET   |Get-DattoRMMSystem                |
|System       |/v2/system/request_rate                     |GET   |Get-DattoRMMSystem                |
|System       |/v2/system/pagination                       |GET   |Get-DattoRMMSystem                |
|User         |/v2/user/resetApiKeys                       |POST  |Reset-DattoRMMUserApiKey          |
