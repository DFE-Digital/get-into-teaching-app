# Application Disaster Recovery

## Plan

Disaster Recover (DR) follows the principles outlined in the [Becoming a Teacher  Disaster recovery plan](https://dfedigital.atlassian.net/wiki/spaces/BaT/pages/2921365676/Disaster+recovery).

## Specific to Get Into Teaching

The Postgres database used by Get into Teaching only stores user-submitted feedback responses. These are not critical to the functioning of the website but could be restored from a backup after the service is back online.

In the event of a total failure a delivery to the system will rebuild what is necessary, via the terraform deployments.
