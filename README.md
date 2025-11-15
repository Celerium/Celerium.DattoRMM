<h1 align="center">
  <br>
  <a href="https://DattoRMM.com"><img src="https://raw.githubusercontent.com/Celerium/Celerium.DattoRMM/refs/heads/main/.github/images/PoSHGallery_Celerium.DattoRMM.png" alt="Celerium.DattoRMM" width="200"></a>
  <br>
  Celerium.DattoRMM
  <br>
</h1>

[![Az_Pipeline][Az_Pipeline-shield]][Az_Pipeline-url]
[![GitHub_Pages][GitHub_Pages-shield]][GitHub_Pages-url]

[![PoshGallery_Version][PoshGallery_Version-shield]][PoshGallery_Version-url]
[![PoshGallery_Platforms][PoshGallery_Platforms-shield]][PoshGallery_Platforms-url]
[![PoshGallery_Downloads][PoshGallery_Downloads-shield]][PoshGallery_Downloads-url]
[![codeSize][codeSize-shield]][codeSize-url]

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

[![GitHub_License][GitHub_License-shield]][GitHub_License-url]

<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://DattoRMM.com">
    <img src="https://raw.githubusercontent.com/Celerium/Celerium.DattoRMM/refs/heads/main/.github/images/PoSHGitHub_Celerium.DattoRMM.png" alt="Logo">
  </a>

  <p align="center">
    <a href="https://www.powershellgallery.com/packages/Celerium.DattoRMM" target="_blank">PowerShell Gallery</a>
    ·
    <a href="https://github.com/Celerium/Celerium.DattoRMM/issues/new/choose" target="_blank">Report Bug</a>
    ·
    <a href="https://github.com/Celerium/Celerium.DattoRMM/issues/new/choose" target="_blank">Request Feature</a>
  </p>
</div>

---

## About The Project

The [Celerium.DattoRMM](https://www.powershellgallery.com/packages/Celerium.DattoRMM) PowerShell wrapper offers the ability to read, create, and update much of the data within DattoRMM's documentation platform. That includes sites, devices, variables, and more. This module serves to abstract away the details of interacting with DattoRMM's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using DattoRMM's API to create documentation scripts, automation, and integrations.

- :book: **Celerium.DattoRMM** project documentation can be found on [Github Pages](https://celerium.github.io/Celerium.DattoRMM/)
- :book: DattoRMM's REST API documentation can be found [here](https://rmm.datto.com/help/en/Content/2SETUP/APIv2.htm)

DattoRMM features a REST API that makes use of common HTTP request methods. In order to maintain PowerShell best practices, only approved verbs are used.

- DELETE -> `Remove-`
- GET -> `Get-`
- POST -> `Set`-
- PUT -> `New-`

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `DattoRMM` in an attempt to prevent naming problems.

For example, one might access the /Account or /Site API endpoints by running the following PowerShell command with the appropriate parameters:

```posh
Get-DattoRMMAccount
or
Get-DattoRMMSite -SiteUID 8675309
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Install

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Celerium.DattoRMM) with the following command:

```posh
Install-Module -Name Celerium.DattoRMM
```

- :information_source: This module supports PowerShell 5.0+ and *should* work in PowerShell Core.
- :information_source: If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *main* branch and place the latest version of *Celerium.DattoRMM* from the build folder into the *(default)* `C:\Program Files\WindowsPowerShell\Modules` folder.

**Celerium.DattoRMM** project documentation can be found on [Github Pages](https://celerium.github.io/Celerium.DattoRMM/)

- A full list of functions can be retrieved by running `Get-Command -Module Celerium.DattoRMM`.
- Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-DattoRMMUser
Get-Help Get-DattoRMMUser -Full
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Initial Setup

After installing this module, you will need to configure both the *base URI* & *API access token* that are used to talk with the DattoRMM API.

1. Run `Add-DattoRMMBaseURI -DataCenter {DataCenter Name}`
   - If you have your own API gateway or proxy, you may put in your own custom URI by specifying the `-BaseUri` parameter:
      - `Add-DattoRMMBaseURI -BaseUri http://myapi.gateway.celerium.org`
      <br>

2. Run `Add-DattoRMMAPIKey -ApiKey 8675309 -ApiSecretKey 8675309`
   - It will prompt you to enter your API keys if you do not specify it.
   - DattoRMM API keys are generated via the DattoRMM portal at *Users > {User} > API*
   <br>

3. Run `Request-DattoRMMAccessToken`
   - Requests an JWT access token using the previous Api keys
   <br>

4. [**optional**] Run `Export-DattoRMMModuleSettings`
   - This will create a config file at `%UserProfile%\Celerium.DattoRMM` that holds the *base uri* & *API access token* information.
   - Next time you run `Import-Module -Name Celerium.DattoRMM`, this configuration file will automatically be loaded.
   - :warning: Exporting module settings encrypts your API access token in a format that can **only be unencrypted by the user principal** that encrypted the secret. It makes use of .NET DPAPI, which for Windows uses reversible encrypted tied to your user principal. This means that you **cannot copy** your configuration file to another computer or user account and expect it to work.
   - :warning: However in Linux\Unix operating systems the secret keys are more obfuscated than encrypted so it is recommend to use a more secure & cross-platform storage method.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Usage

Calling an API resource is as simple as running `Get-DattoRMM<resourceName>`

- The following is a table of supported functions and their corresponding API resources:
- Example scripts can be found in the [examples](https://github.com/Celerium/Celerium.DattoRMM/tree/main/examples) folder of this repository.

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

:warning: Each `Get-DattoRMM*` functions return is sent back in a modified object. Most DattoRMM endpoints returned their data
in property names that are unique to their endpoint. I take this data and return everything in a consistent structured output.

- `pageDetails` - Information about the number of pages of results are available and other metadata.
- `data` - The actual information requested (this is what most people care about)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions are what makes the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

See the [CONTRIBUTING](https://github.com/Celerium/Celerium.DattoRMM/blob/master/.github/CONTRIBUTING.md) guide for more information about contributing.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## License

Distributed under the MIT license. See [LICENSE](https://github.com/Celerium/Celerium.DattoRMM/blob/master/LICENSE) for more information.

[![GitHub_License][GitHub_License-shield]][GitHub_License-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[Az_Pipeline-shield]:               https://img.shields.io/azure-devops/build/AzCelerium/Celerium.DattoRMM/15?style=for-the-badge&label=DevOps_Build
[Az_Pipeline-url]:                  https://dev.azure.com/AzCelerium/Celerium.DattoRMM/_build?definitionId=15

[GitHub_Pages-shield]:              https://img.shields.io/github/actions/workflow/status/celerium/Celerium.DattoRMM/pages%2Fpages-build-deployment?style=for-the-badge&label=GitHub%20Pages
[GitHub_Pages-url]:                 https://github.com/Celerium/Celerium.DattoRMM/actions/workflows/pages/pages-build-deployment

[GitHub_License-shield]:            https://img.shields.io/github/license/celerium/Celerium.DattoRMM?style=for-the-badge
[GitHub_License-url]:               https://github.com/Celerium/Celerium.DattoRMM/blob/master/LICENSE

[PoshGallery_Version-shield]:       https://img.shields.io/powershellgallery/v/Celerium.DattoRMM?include_prereleases&style=for-the-badge
[PoshGallery_Version-url]:          https://www.powershellgallery.com/packages/Celerium.DattoRMM

[PoshGallery_Platforms-shield]:     https://img.shields.io/powershellgallery/p/Celerium.DattoRMM?style=for-the-badge
[PoshGallery_Platforms-url]:        https://www.powershellgallery.com/packages/Celerium.DattoRMM

[PoshGallery_Downloads-shield]:     https://img.shields.io/powershellgallery/dt/Celerium.DattoRMM?style=for-the-badge
[PoshGallery_Downloads-url]:        https://www.powershellgallery.com/packages/Celerium.DattoRMM

[codeSize-shield]:                  https://img.shields.io/github/repo-size/celerium/Celerium.DattoRMM?style=for-the-badge
[codeSize-url]:                     https://github.com/Celerium/Celerium.DattoRMM

[contributors-shield]:              https://img.shields.io/github/contributors/celerium/Celerium.DattoRMM?style=for-the-badge
[contributors-url]:                 https://github.com/Celerium/Celerium.DattoRMM/graphs/contributors

[forks-shield]:                     https://img.shields.io/github/forks/celerium/Celerium.DattoRMM?style=for-the-badge
[forks-url]:                        https://github.com/Celerium/Celerium.DattoRMM/network/members

[stars-shield]:                     https://img.shields.io/github/stars/celerium/Celerium.DattoRMM?style=for-the-badge
[stars-url]:                        https://github.com/Celerium/Celerium.DattoRMM/stargazers

[issues-shield]:                    https://img.shields.io/github/issues/Celerium/Celerium.DattoRMM?style=for-the-badge
[issues-url]:                       https://github.com/Celerium/Celerium.DattoRMM/issues
