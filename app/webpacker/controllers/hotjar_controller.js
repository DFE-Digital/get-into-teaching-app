import AnalyticsBaseController from './analytics_base_controller';

export default class extends AnalyticsBaseController {
  get serviceId() {
    return this.getServiceId('hotjar-id');
  }

  get serviceFunction() {
    return window.hj;
  }

  get cookieCategory() {
    return 'non-functional';
  }

  initService() {
    // IMPORTANT: see line marked below
    // the 'a' variable was originally used in the function call
    // This is just to make their method signature look 'clever'
    // it then gets overwritten by the getElements line
    // This mucks with supplying additional parameters, eg the serviceId
    // So I'm just reading a into the _hjSettings prior to it getting overwitten

    (function (h, o, t, j, a, r) {
      h.hj =
        h.hj ||
        function () {
          (h.hj.q = h.hj.q || []).push(arguments);
        };
      h._hjSettings = { hjid: a, hjsv: 6 }; // IMPORTANT
      a = o.getElementsByTagName('head')[0];
      r = o.createElement('script');
      r.async = 1;
      r.src = t + h._hjSettings.hjid + j + h._hjSettings.hjsv;
      a.appendChild(r);
    })(
      window,
      document,
      'https://static.hotjar.com/c/hotjar-',
      '.js?sv=',
      this.serviceId
    );
  }

  get isEnabled() {
    return !!this.serviceId;
  }

  sendEvent() {
    /* No-op HotJar notices the page history update */
  }
}
