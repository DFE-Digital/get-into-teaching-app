import * as Sentry from "@sentry/browser";

const sentryConfig = document.querySelector("[data-sentry-dsn]")?.dataset;

if (sentryConfig) {
  Sentry.init({
    dsn: sentryConfig.sentryDsn,
    environment: sentryConfig.sentryEnvironment,
  });
}
