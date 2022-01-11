import * as Sentry from "@sentry/browser";

const sentryConfig = document.querySelector("[data-sentry-dsn]")?.dataset;

if (sentryConfig) {
  Sentry.init({
    dsn: sentryConfig.sentryDsn,
    environment: sentryConfig.sentryEnvironment,
  });
}

import '@stimulus/polyfills';
import "core-js/stable";
import "regenerator-runtime/runtime";
import '../styles/application.scss';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

import 'controllers';

require.context('../fonts', true);
require.context('../images', true);
require.context('../documents', true);

require('../javascript/zendesk_chat_reload');

Rails.start();
Turbolinks.start();
