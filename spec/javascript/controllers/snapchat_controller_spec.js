import AnalyticsHelper from './analytics_spec_helper';
import SnapchatController from 'snapchat_controller';

describe('SnapchatController', () => {
  document.head.innerHTML = `<script></script>`;
  document.body.innerHTML = `
  <div data-controller="snapchat" data-snapchat-action="test" data-snapchat-event="test"></div>
  `;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => {
    delete window.snaptr;
  });

  AnalyticsHelper.describeWithCookieSet(
    'snapchat',
    SnapchatController,
    'snaptr',
    'marketing'
  );
  AnalyticsHelper.describeWhenEventFires(
    'snapchat',
    SnapchatController,
    'snaptr',
    'marketing'
  );
});
