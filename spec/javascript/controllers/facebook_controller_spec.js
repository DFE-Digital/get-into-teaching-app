import AnalyticsHelper from './analytics_spec_helper';
import FacebookController from 'facebook_controller';

describe('FacebookController', () => {
  document.head.innerHTML = `<script></script>`;
  document.body.innerHTML = `
  <div
    data-controller="facebook"
    data-facebook-action="test"
    data-facebook-event="test">
  </div>
  `;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => {
    delete window.fbq;
  });

  AnalyticsHelper.describeWithCookieSet(
    'facebook',
    FacebookController,
    'fbq',
    'marketing'
  );
  AnalyticsHelper.describeWhenEventFires(
    'facebook',
    FacebookController,
    'fbq',
    'marketing'
  );
});
