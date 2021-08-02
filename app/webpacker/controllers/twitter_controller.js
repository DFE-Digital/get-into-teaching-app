import AnalyticsBaseController from './analytics_base_controller';

export default class extends AnalyticsBaseController {
  get serviceId() {
    return this.getServiceId('twitter-id');
  }

  get serviceFunction() {
    return window.twq;
  }

  /* eslint-disable */
  initService() {
    !(function (e, t, n, s, u, a) {
      e.twq ||
        ((s = e.twq =
          function () {
            s.exe ? s.exe.apply(s, arguments) : s.queue.push(arguments);
          }),
        (s.version = '1.1'),
        (s.queue = []),
        (u = t.createElement(n)),
        (u.async = !0),
        (u.src = '//static.ads-twitter.com/uwt.js'),
        (a = t.getElementsByTagName(n)[0]),
        a.parentNode.insertBefore(u, a));
    })(window, document, 'script');

    // Insert Twitter Pixel ID and Standard Event data below
    window.twq('init', this.serviceId);
  }
}
