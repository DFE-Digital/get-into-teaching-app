import AnalyticsBaseController from "./analytics_base_controller"

export default class extends AnalyticsBaseController {

  get serviceId() {
    return this.getServiceId('gtm-id') ;
  }

  get serviceFunction() {
    return window.gtag ;
  }

  get cookieCategory() {
    return 'non-functional' ;
  }

  gtmFunction(w,d,s,l,i) {
    w[l] = w[l] || [];
    w[l].push({
      'gtm.start': new Date().getTime(),
      event: 'gtm.js'
    });
    var
      f = d.getElementsByTagName(s)[0],
      j = d.createElement(s),
      dl = (l!='dataLayer' ? '&l='+l : '');
    j.async = true;
    j.src = 'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
    f.parentNode.insertBefore(j,f);
  }

  initService() {
    this.gtmFunction(window, document, 'script', 'dataLayer', this.serviceId);

    /* this is added for simplicity */
    window.gtag = function() {
      window.dataLayer.push(arguments);
    }
  }

  get isEnabled() {
    return !!this.serviceId ;
  }

  sendEvent() {
    /* No-op GTM notices the page history update */
  }

}

