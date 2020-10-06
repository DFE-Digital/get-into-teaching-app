/* This is to allow us to log to a second GTM container */

import GtmController from "./gtm_controller"

export default class extends GtmController {

  get serviceId() {
    return this.getServiceId('gtm2-id') ;
  }

  get serviceFunction() {
    return window.gtag2 ;
  }

  get cookieCategory() {
    return 'non-functional' ;
  }

  initService() {
    this.gtmFunction(window, document, 'script', 'dataLayer2', this.serviceId);

    /* this is added for simplicity */
    window.gtag2 = function() {
      window.dataLayer2.push(arguments);
    }
  }

}

