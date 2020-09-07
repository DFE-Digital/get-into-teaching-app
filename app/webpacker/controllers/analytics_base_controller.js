import { Controller } from "stimulus"

export default class extends Controller {

  connect() {
    if(document.cookie.indexOf('GiTBetaCookie=Accepted') > -1) {
      this.triggerEvent() ;
    } else {
      this.triggerEventHandler = this.triggerEvent.bind(this)
      document.addEventListener("cookies:accepted", this.triggerEventHandler) ;
    }
  }

  disconnect() {
    if (this.analyticsAcceptedHandler) {
      document.removeEventListener("cookies:accepted", this.triggerEventHandler) ;
    }
  }

  get isEnabled() {
    return (this.serviceId && this.data.has('action')) ;
  }

  triggerEvent() {
    if (document.documentElement.hasAttribute("data-turbolinks-preview"))
      return ;

    if (!this.isEnabled) return ;

    if (!this.serviceFunction)
      this.initService() ;

    this.sendEvent() ;
  }

  getServiceId(attribute) {
    const value = document.body.getAttribute('data-analytics-' + attribute) ;
    return (value && value.trim() != "") ? value.trim() : null ;
  }

  get serviceAction() {
    return this.data.get('action') ;
  }

  get eventName() {
    return this.data.get('event') ;
  }

  get eventData() {
    if (typeof(this.parsedEventData) != "undefined")
      return this.parsedEventData ;

    let evData = this.data.get('event-data') ;
    this.parsedEventData = null ;

    if (evData && evData != "")
      this.parsedEventData = JSON.parse(evData) ;

    return this.parsedEventData ;
  }

  sendEvent() {
    if (this.eventData)
      this.serviceFunction(this.serviceAction, this.eventName, this.eventData) ;
    else if (this.eventName)
      this.serviceFunction(this.serviceAction, this.eventName) ;
    else
      this.serviceFunction(this.serviceAction) ;
  }

}

