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

  initService() {
    (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer',this.serviceId);

    /* this is added for simplicity but is not compatible with multiple GTM containers */
    /* We dont support that anyway so its not an issue here */
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

