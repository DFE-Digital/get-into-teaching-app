import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['modal', 'overlay', 'agree', 'disagree'];

  connect() {
    if (!this.isPrivacyPage()) {
      this.checkforCookie();
    }
  }

  checkforCookie() {
    const cookiePrefs = new CookiePreferences();
    if (cookiePrefs.cookieSet) return;

    this.showDialog();
  }

  accept(event) {
    event.preventDefault();
    this.overlayTarget.style.display = 'none';

    const cookiePrefs = new CookiePreferences();
    cookiePrefs.allowAll();
  }

  showDialog() {
    this.overlayTarget.style.display = 'flex';
    document.getElementById('biscuits-agree').focus();

    this.disagreeTarget.addEventListener('blur', function (e) {
      e.preventDefault();
      document.getElementById('biscuits-agree').focus();
    });

    this.agreeTarget.addEventListener('blur', function (e) {
      e.preventDefault();
      document.getElementById('cookies-disagree').focus();
    });
  }

  isPrivacyPage() {
    const path = window.location.href.replace(/^https?:\/\/[^/]+/, '');
    const cookiesPages = ['/cookie_preference', '/cookies', '/privacy-policy'];

    return cookiesPages.includes(path);
  }
}
