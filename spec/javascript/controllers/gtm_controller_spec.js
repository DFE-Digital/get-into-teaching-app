import AnalyticsHelper from './analytics_spec_helper';
import GtmController from 'gtm_controller';

describe('GtmController', () => {
  document.head.innerHTML = `<script></script>`;
  document.body.innerHTML = `
  <div data-controller="gtm" data-gtm-action="test" data-gtm-event="test"></div>
  `;
  document.body.setAttribute('data-analytics-adwords-id', 'AD-456');

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => {
    delete window.gtag;
  });

  AnalyticsHelper.describeWithCookieSet(
    'gtm',
    GtmController,
    'gtag',
    'non-functional'
  );
  AnalyticsHelper.describeWhenEventFires(
    'gtm',
    GtmController,
    'gtag',
    'non-functional'
  );
});
