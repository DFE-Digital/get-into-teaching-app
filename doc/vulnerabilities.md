# Vulnerabilities

The [Brakeman](https://brakemanscanner.org/) and [Anchore](https://anchore.com/) scanners are employed to search for vulnerabilites in the code, and dependabot is used to resolve them where possible.  In some cases dependabot will not resolve a vulnerability and it needs to be carried out manually.

Anchore scans are uploaded to GitHub [Code Scanning alerts](https://github.com/DFE-Digital/get-into-teaching-app/security/code-scanning)

The scanners produce alerts at Critical, High, Medium and Low levels. Because of the sheer amount of alerts, we are only scanning for Critical and High alerts. Anything below that level will be closed as 'Will Not Fix'

There are cases where Anchore will find a 'false positive' or the latest version of package cannot be resolved, these will be documented below:

|  Package | Type | Version | Comments | 
|:--------:|------|---------|----------| 
| foreman  | Gem  | 0.87.2  | Latest version of Gem | 
| builder  | Gem  | 3.2.4   | Latest version of Gem |  
| zlib     | Gem  | 1.1.0   | Latest version of Gem | 
| logger   | Gem  | 1.4.3   | Latest version of Gem | 
| i18n     | Gem  | 1.8.10  | Latest version of Gem | 
| json     | Gem  | 2.5.1   | Latest version of Gem | 
| json     | Gem  | 2.3.0   | False Positive        |
| delegate | Gem  | 0.2.0   | Latest version of Gem | 
| Redis    | Gem  | 4.3.1   | Latest version of Gem |
| rexml    | Gem  | 3.2.5   | Latest version of Gem |
| matrix   | Gem  | 0.4.2   | Latest version of Gem | 
| mail     | Gem  | 2.7.1   | Latest version of Gem |
| base     | NPM  | 0.11.2  |
| observer | Gem  | 0.1.1   | Latest version of Gem | 

