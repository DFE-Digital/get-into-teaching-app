import AnalyticsHelper from './analytics_spec_helper' ;
import HotjarController from 'hotjar_controller' ;

describe('HotjarController', () => {
  document.head.innerHTML = `<script></script>` ;
  document.body.innerHTML = `
  <div data-controller="hotjar"></div>
  ` ;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => { delete window.hj })

  AnalyticsHelper.describeWithCookieSet('hotjar', HotjarController, 'hj')
  AnalyticsHelper.describeWhenEventFires('hotjar', HotjarController, 'hj')
})
