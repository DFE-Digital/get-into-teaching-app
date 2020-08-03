import AnalyticsBaseController from "./analytics_base_controller"

export default class extends AnalyticsBaseController {

  get serviceId() {
    return this.getServiceId('gtm-id') ;
  }

  get serviceFunction() {
    return window.gtag ;
  }

  initService() {
    window.dataLayer = window.dataLayer || [];
    window.gtag = function (){dataLayer.push(arguments);}

    var e="https://www.googletagmanager.com/gtag/js?id=" + this.serviceId ;
    var t=document.createElement("script");t.async=true,t.src=e;var
    r=document.getElementsByTagName("script")[0];
    r.parentNode.insertBefore(t,r) ;

    window.gtag('js', new Date());
    window.gtag('config', this.serviceId);
  }

}

