import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    this.updateGtm();

    document.addEventListener('cookies:accepted', this.updateGtm.bind(this));
  }

  disconnect() {
    if (!document) {
      return;
    }

    document.removeEventListener('cookies:accepted', this.updateGtm.bind(this));
  }

  updateGtm() {
    window.gtag('consent', 'update', {
      analytics_storage: this.consentValue('non-functional'),
      ad_storage: this.consentValue('marketing'),
    });
  }

  consentValue(category) {
    const cookiePrefs = new CookiePreferences();

    return cookiePrefs.allowedCategories.includes(category)
      ? 'granted'
      : 'denied';
  }
}
