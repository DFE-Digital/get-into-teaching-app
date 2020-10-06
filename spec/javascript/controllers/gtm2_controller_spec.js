import AnalyticsHelper from './analytics_spec_helper' ;
import Gtm2Controller from 'gtm2_controller' ;

describe('GtmController', () => {
  document.head.innerHTML = `<script></script>` ;
  document.body.innerHTML = `
  <div data-controller="gtm2" data-gtm2-action="test" data-gtm2-event="test"></div>
  ` ;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => { delete window.gtag2 })

  AnalyticsHelper.describeWithCookieSet('gtm2', Gtm2Controller, 'gtag2', 'non-functional')
  AnalyticsHelper.describeWhenEventFires('gtm2', Gtm2Controller, 'gtag2', 'non-functional')
})
