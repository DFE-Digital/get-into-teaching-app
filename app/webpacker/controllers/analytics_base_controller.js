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

  triggerEvent() {
    if (!this.serviceId || !this.data.has('action') || !this.data.has('event'))
      return

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
    let evData = this.data.get('event-data') ;

    if (evData && evData != "")
      return JSON.parse(evData) ;
    else
      return null ;
  }

  sendEvent() {
    let evData = this.eventData ;

    if (evData)
      this.serviceFunction(this.serviceAction, this.eventName, evData) ;
    else
      this.serviceFunction(this.serviceAction, this.eventName) ;
  }

}

