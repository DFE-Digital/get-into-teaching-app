import AnalyticsHelper from './analytics_spec_helper' ;
import TwitterController from 'twitter_controller' ;

describe('FacebookController', () => {
  document.head.innerHTML = `<script></script>` ;
  document.body.innerHTML = `
  <div
    data-controller="twitter"
    data-twitter-action="test"
    data-twitter-event="test">
  </div>
  ` ;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => { delete window.twq })

  AnalyticsHelper.describeWithCookieSet('twitter', TwitterController, 'twq', 'marketing')
  AnalyticsHelper.describeWhenEventFires('twitter', TwitterController, 'twq', 'marketing')
})
