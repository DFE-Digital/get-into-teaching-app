# Get Into Teaching

A service for candidates to [get-into-teaching](https://getintoteaching.education.gov.uk/). 

## Status

[![View performance data on Skylight](https://badges.skylight.io/status/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)
[![View traffic data on Skylight](https://badges.skylight.io/rpm/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)
[![View typical response times on Skylight](https://badges.skylight.io/typical/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)
[![View problem response times on Skylight](https://badges.skylight.io/problem/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)
[![Build and Deploy](https://github.com/DFE-Digital/get-into-teaching-app/actions/workflows/build.yml/badge.svg)](https://github.com/DFE-Digital/get-into-teaching-app/actions/workflows/build.yml)

## Table of Contents

- [Environments](#environments)
- [Guides](#guides)
- [Application Specific](#guides)
- [License](#license)

## Environments

The website is deployed to GOV.UK PAAS. The environments can be confusing because our Rails environments are named differently (we should look to address this as part of the migration away from GOV.UK PAAS!). Here is a table to try and make sense of the combinations:

| Environment             | Rails Environment | Description                           | URL                                                              |
| ----------------------- | ----------------- | ------------------------------------- | ---------------------------------------------------------------- |
| development (PAAS)      | rolling           | Internal use/testing                  | https://get-into-teaching-app-dev.london.cloudapps.digital       |
| test (PAAS)             | preprod           | Internal use/testing                  | https://get-into-teaching-app-test.london.cloudapps.digital      |
| production (PASS)       | production        | Public                                | https://getintoteaching.education.gov.uk                         |
| pagespeed (PASS)        | pagespeed         | Runs periodic page speed analytics    | https://get-into-teaching-app-pagespeed.london.cloudapps.digital |
| ur (PASS)               | preprod           | User research sessions                | https://get-into-teaching-app-ur.london.cloudapps.digital        | 
| development (local)     | development       | Local development                     | 0.0.0.0:3000                                                     |
| test (local)            | test              | Local test suite                      | n/a                                                              |

## Guides

- [Dfe Technical Guidence](https://technical-guidance.education.gov.uk/)

## Application Specific Guides

- [Configuration](/docs/configuration.md)
- [Development](/docs/development.md)
- [Deployment](/docs/deployment.md)
- [Monitoring](/docs/monitoring.md)
- [Content](/docs/content.md)
- [Codespaces](/docs/codespaces.md)
- [Events Portal](/docs/events-portal.md)
- [Disaster Recovery Plan](/docs/disaster-recovery.md)
- [Sign Up Journeys](/docs/sign-up-journeys.md)

## License

[MIT Licence](LICENCE)

