import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    const cookiePrefs = new CookiePreferences();
    const cookiesAccepted = cookiePrefs.allowed(this.cookieCategory);

    if (cookiesAccepted) {
      this.triggerEvent();
    }

    if (!cookiesAccepted) {
      this.cookiesAcceptedHandler = this.cookiesAcceptedChecker.bind(this);
      document.addEventListener(
        'cookies:accepted',
        this.cookiesAcceptedHandler
      );
    }
  }

  disconnect() {
    if (document && this.analyticsAcceptedHandler) {
      document.removeEventListener(
        'cookies:accepted',
        this.cookiesAcceptedHandler
      );
    }
  }

  get cookieCategory() {
    return 'marketing';
  }

  get isEnabled() {
    return this.serviceId && this.data.has('action');
  }

  triggerEvent() {
    if (document.documentElement.hasAttribute('data-turbo-preview')) return;

    if (!this.isEnabled) return;

    if (!this.serviceFunction) this.initService();

    this.sendEvent();
  }

  cookiesAcceptedChecker(event) {
    if (event.detail?.cookies?.includes(this.cookieCategory)) {
      this.triggerEvent();
    }
  }

  getServiceId(attribute) {
    const value = document.body.getAttribute('data-analytics-' + attribute);
    return value && value.trim() !== '' ? value.trim() : null;
  }

  get serviceAction() {
    return this.data.get('action');
  }

  get eventName() {
    return this.data.get('event');
  }

  get eventData() {
    if (typeof this.parsedEventData !== 'undefined')
      return this.parsedEventData;

    const evData = this.data.get('event-data');
    this.parsedEventData = null;

    if (evData && evData !== '') this.parsedEventData = JSON.parse(evData);

    return this.parsedEventData;
  }

  sendEvent() {
    if (this.eventData)
      this.serviceFunction(this.serviceAction, this.eventName, this.eventData);
    else if (this.eventName)
      this.serviceFunction(this.serviceAction, this.eventName);
    else this.serviceFunction(this.serviceAction);
  }
}
