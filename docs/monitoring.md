# Monitoring

## Logs

We use [logit.io](https://kibana.logit.io/app/kibana) to host a Kibana instance for our logs. The logs persist for **14 days** and contain logs for all our production and test instances. You can filter to a specific instance using the `cf.app` field.

## Metrics

We use [Prometheus](https://prometheus-prod-get-into-teaching.london.cloudapps.digital/) to collect our metrics into an InfluxDB instance. The metrics are presented using [Grafana](https://grafana-prod-get-into-teaching.london.cloudapps.digital/). All the configuration/infrastructure is currently configured in the GiT API terraform files. The metrics are advertised on the `/metrics` endpoint of the application.

Note that if you change the Grafana dashboard **it will not persist** and you need to instead export the dashboard and [updated it in the GitHub repository](https://github.com/DFE-Digital/get-into-teaching-api/tree/master/monitoring/grafana/dashboards). These are re-applied on API deployment.

## Alerts

We use [Prometheus Alert Manager](https://alertmanager-prod-get-into-teaching.london.cloudapps.digital/#/alerts) to notify us when something has gone wrong. It will post to the relevant Slack channel and contain a link to the appropriate Grafana dashboard and/or runbook.

You can add/configure alerts in the [GiT API repository](https://github.com/DFE-Digital/get-into-teaching-api/blob/master/monitoring/prometheus/alert.rules).

All the runbooks are also [hosted in the GiT API repository](https://github.com/DFE-Digital/get-into-teaching-api/tree/master/docs/runbooks).

## Error reporting

We use [Sentry](sentry.io) to capture application errors. They will be posted to the relvant Slack channel when they first occur.

## External link checking

External links are now tested using [Lychee](https://github.com/lycheeverse/lychee).

Install it using your package manager of choice or download the binary
[from GitHub](https://github.com/lycheeverse/lychee/releases) and make it
executable.

```bash
lychee --insecure --exclude-mail app/views/content
```

We run this on a nightly schedule in a GitHub Action and broken links are reported via Slack.
