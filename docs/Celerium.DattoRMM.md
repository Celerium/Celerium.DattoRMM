---
parent: Home 
Module Name: Celerium.DattoRMM
Module Guid: c2d6db6b-874b-49ec-b9d9-ec5db3f141a9
Download Help Link: https://celerium.github.io/Celerium.DattoRMM/docs/cab
Help Version: 1.0.0.0
Locale: en-US
---

# Celerium.DattoRMM Module
## Description
This PowerShell module acts as a wrapper for the DattoRMM API.

## Celerium.DattoRMM Cmdlets
### [Add-DattoRMMAPIKey](site/Internal/Add-DattoRMMAPIKey.md)
Sets your API key used to authenticate all API calls

### [Add-DattoRMMBaseURI](site/Internal/Add-DattoRMMBaseURI.md)
Sets the base URI for the DattoRMM API connection

### [ConvertTo-DattoRMMQueryString](site/Internal/ConvertTo-DattoRMMQueryString.md)
Converts uri filter parameters

### [Export-DattoRMMModuleSettings](site/Internal/Export-DattoRMMModuleSettings.md)
Exports the DattoRMM BaseURI, API, & JSON configuration information to file

### [Get-DattoRMMAccessToken](site/Internal/Get-DattoRMMAccessToken.md)
Gets the stored JWT access token

### [Get-DattoRMMAccount](site/Account/Get-DattoRMMAccount.md)
Fetches the authenticated user's account data.

### [Get-DattoRMMAccountAlert](site/Account/Get-DattoRMMAccountAlert.md)
Fetches the account alerts

### [Get-DattoRMMAccountComponent](site/Account/Get-DattoRMMAccountComponent.md)
Fetches the account components

### [Get-DattoRMMAccountDevice](site/Account/Get-DattoRMMAccountDevice.md)
Fetches the devices of the authenticated user's account.

### [Get-DattoRMMAccountDnetSiteMapping](site/Account/Get-DattoRMMAccountDnetSiteMapping.md)
Get the sites records with its mapped dnet network id for
the authenticated user's account

### [Get-DattoRMMAccountSite](site/Account/Get-DattoRMMAccountSite.md)
Fetches the site records of the authenticated user's account

### [Get-DattoRMMAccountUser](site/Account/Get-DattoRMMAccountUser.md)
Fetches the authentication users records of the
authenticated user's account

### [Get-DattoRMMAccountVariable](site/Account/Get-DattoRMMAccountVariable.md)
Fetches the account variables

### [Get-DattoRMMActivityLog](site/Activity-Logs/Get-DattoRMMActivityLog.md)
Fetches the activity logs

### [Get-DattoRMMAlert](site/Audit/Get-DattoRMMAlert.md)
Fetches data of the alert identified by the given alert Uid

### [Get-DattoRMMAPIKey](site/Internal/Get-DattoRMMAPIKey.md)
Gets the DattoRMM API key

### [Get-DattoRMMAuditDevice](site/Audit/Get-DattoRMMAuditDevice.md)
Fetches audit data of the generic device identified the given device Uid

### [Get-DattoRMMAuditESXI](site/Audit/Get-DattoRMMAuditESXI.md)
Fetches audit data of the ESXi host identified the given device Uid

### [Get-DattoRMMAuditPrinter](site/Audit/Get-DattoRMMAuditPrinter.md)
Fetches audit data of the printer identified with the given device Uid

### [Get-DattoRMMBaseURI](site/Internal/Get-DattoRMMBaseURI.md)
Shows the DattoRMM base URI

### [Get-DattoRMMDevice](site/Device/Get-DattoRMMDevice.md)
Fetches data of the device identified by the given device Uid

### [Get-DattoRMMDeviceAlert](site/Device/Get-DattoRMMDeviceAlert.md)
Fetches the alerts of the device identified by the given device Uid

### [Get-DattoRMMFilter](site/Filter/Get-DattoRMMFilter.md)
Gets both default & custom filters

### [Get-DattoRMMJob](site/Job/Get-DattoRMMJob.md)
Fetches data of the job identified by the given job Uid

### [Get-DattoRMMJobResult](site/Job/Get-DattoRMMJobResult.md)
Fetches job results of the job identified by the job Uid
for device identified by the device Uid

### [Get-DattoRMMModuleSettings](site/Internal/Get-DattoRMMModuleSettings.md)
Gets the saved DattoRMM configuration settings

### [Get-DattoRMMSite](site/Site/Get-DattoRMMSite.md)
Fetches data of the site (including total number of devices)
identified by the given site Uid

### [Get-DattoRMMSiteAlert](site/Site/Get-DattoRMMSiteAlert.md)
Fetches the alerts of the site identified by the given site Uid

### [Get-DattoRMMSiteDevice](site/Site/Get-DattoRMMSiteDevice.md)
Fetches the devices records of the site identified by the given site Uid

### [Get-DattoRMMSiteFilter](site/Site/Get-DattoRMMSiteFilter.md)
Fetches the site device filters (that the user can see with administrator role)
of the site identified by the given site Uid

### [Get-DattoRMMSiteSetting](site/Site/Get-DattoRMMSiteSetting.md)
Fetches settings of the site identified by the given site Uid

### [Get-DattoRMMSiteVariable](site/Site/Get-DattoRMMSiteVariable.md)
Fetches the variables of the site identified by the given site Uid

### [Get-DattoRMMSystem](site/System/Get-DattoRMMSystem.md)
Gets various DattoRMM system operation information

### [Import-DattoRMMModuleSettings](site/Internal/Import-DattoRMMModuleSettings.md)
Imports the DattoRMM BaseURI, API, & JSON configuration information to the current session

### [Invoke-DattoRMMRequest](site/Internal/Invoke-DattoRMMRequest.md)
Makes an API request to DattoRMM

### [Move-DattoRMMDevice](site/Device/Move-DattoRMMDevice.md)
Moves a device from one site to another site

### [New-DattoRMMAccountVariable](site/Account/New-DattoRMMAccountVariable.md)
Creates an account variable

### [New-DattoRMMDeviceJob](site/Device/New-DattoRMMDeviceJob.md)
Creates a quick job on the device identified by the given device Uid

### [New-DattoRMMSite](site/Site/New-DattoRMMSite.md)
Creates a new site in the authenticated user's account

### [New-DattoRMMSiteVariable](site/Site/New-DattoRMMSiteVariable.md)
Creates a site variable in the site identified by the
given site Uid

### [Remove-DattoRMMAccountVariable](site/Account/Remove-DattoRMMAccountVariable.md)
Deletes an account variable

### [Remove-DattoRMMAPIKey](site/Internal/Remove-DattoRMMAPIKey.md)
Removes the Api & Api secret keys from the global variables

### [Remove-DattoRMMBaseURI](site/Internal/Remove-DattoRMMBaseURI.md)
Removes the DattoRMM base URI global variable

### [Remove-DattoRMMModuleSettings](site/Internal/Remove-DattoRMMModuleSettings.md)
Removes the stored DattoRMM configuration folder

### [Remove-DattoRMMSiteProxy](site/Site/Remove-DattoRMMSiteProxy.md)
Deletes site proxy settings for the site identified by the given site Uid

### [Remove-DattoRMMSiteVariable](site/Site/Remove-DattoRMMSiteVariable.md)
Deletes the site variable identified by the given site Uid and variable Id

### [Request-DattoRMMAccessToken](site/Internal/Request-DattoRMMAccessToken.md)
Requests an JWT access token using the users Api keys

### [Reset-DattoRMMUserApiKey](site/User/Reset-DattoRMMUserApiKey.md)
Resets the authenticated user's API access and secret keys

### [Set-DattoRMMAccountVariable](site/Account/Set-DattoRMMAccountVariable.md)
Updates an account variable

### [Set-DattoRMMAlert](site/Alert/Set-DattoRMMAlert.md)
Updates (resolves) an alert

### [Set-DattoRMMDeviceUDF](site/Device/Set-DattoRMMDeviceUDF.md)
Sets the user defined fields of a device identified by
the given device Uid

### [Set-DattoRMMDeviceWarranty](site/Device/Set-DattoRMMDeviceWarranty.md)
Sets the warranty of a device identified by the given device Uid

### [Set-DattoRMMSite](site/Site/Set-DattoRMMSite.md)
Updates the site identified by the given site Uid

### [Set-DattoRMMSiteProxy](site/Site/Set-DattoRMMSiteProxy.md)
Creates/updates the proxy settings for the site identified
by the given site Uid

### [Set-DattoRMMSiteVariable](site/Site/Set-DattoRMMSiteVariable.md)
Updates the site variable identified by the given
site Uid and variable Id

### [Test-DattoRMMAPIKey](site/Internal/Test-DattoRMMAPIKey.md)
Test the DattoRMM API key


