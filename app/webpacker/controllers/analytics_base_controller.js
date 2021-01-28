const Cookies = require('js-cookie');
import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    const cookiePrefs = new CookiePreferences();
    const cookiesAccepted = cookiePrefs.allowed(this.cookieCategory);

    if (this.hasVwoCompleted && cookiesAccepted) {
      this.triggerEvent();
    }

    if (!cookiesAccepted) {
      this.cookiesAcceptedHandler = this.cookiesAcceptedChecker.bind(this);
      document.addEventListener(
        'cookies:accepted',
        this.cookiesAcceptedHandler
      );
    }

    if (!this.hasVwoCompleted) {
      this.vwoCompletedHandler = this.vwoCompleted.bind(this);
      document.addEventListener('vwo:completed', this.vwoCompletedHandler);
    }
  }

  disconnect() {
    if (document && this.analyticsAcceptedHandler) {
      document.removeEventListener(
        'cookies:accepted',
        this.cookiesAcceptedHandler
      );
    }

    if (document && this.vwoCompletedHandler) {
      document.removeEventListener('vwo:completed', this.vwoCompletedHandler);
    }
  }

  get cookieCategory() {
    return 'marketing';
  }

  get isEnabled() {
    return this.serviceId && this.data.has('action');
  }

  triggerEvent() {
    // No-op as being redirected away
    if (window.willRedirectionOccurByVWO) return;

    if (document.documentElement.hasAttribute('data-turbolinks-preview'))
      return;

    if (!this.isEnabled) return;

    if (!this.serviceFunction) this.initService();

    this.sendEvent();
  }

  cookiesAcceptedChecker(event) {
    if (
      event.detail?.cookies?.includes(this.cookieCategory) &&
      this.hasVwoCompleted
    )
      this.triggerEvent();
  }

  vwoCompleted(event) {
    const cookiePrefs = new CookiePreferences();
    if (cookiePrefs.allowed(this.cookieCategory)) this.triggerEvent();
  }

  getServiceId(attribute) {
    const value = document.body.getAttribute('data-analytics-' + attribute);
    return value && value.trim() != '' ? value.trim() : null;
  }

  get serviceAction() {
    return this.data.get('action');
  }

  get eventName() {
    return this.data.get('event');
  }

  get eventData() {
    if (typeof this.parsedEventData != 'undefined') return this.parsedEventData;

    let evData = this.data.get('event-data');
    this.parsedEventData = null;

    if (evData && evData != '') this.parsedEventData = JSON.parse(evData);

    return this.parsedEventData;
  }

  sendEvent() {
    if (this.eventData)
      this.serviceFunction(this.serviceAction, this.eventName, this.eventData);
    else if (this.eventName)
      this.serviceFunction(this.serviceAction, this.eventName);
    else this.serviceFunction(this.serviceAction);
  }

  get hasVwoCompleted() {
    return typeof window.willRedirectionOccurByVWO != 'undefined';
  }
}
