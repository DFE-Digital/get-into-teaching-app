import AnalyticsHelper from './analytics_spec_helper' ;
import PinterestController from 'pinterest_controller' ;

describe('PinterestController', () => {
  document.head.innerHTML = `<script></script>` ;
  document.body.innerHTML = `
  <div data-controller="pinterest" data-pinterest-action="test" data-pinterest-event="test"></div>
  ` ;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => { delete window.pintrk })

  AnalyticsHelper.describeWithCookieSet('pinterest', PinterestController, 'pintrk', 'marketing')
  AnalyticsHelper.describeWhenEventFires('pinterest', PinterestController, 'pintrk', 'marketing')
})
