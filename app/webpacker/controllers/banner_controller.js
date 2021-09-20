import Cookies from 'js-cookie';
import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  static values = { name: String };

  cookieCategory = 'functional';

  connect() {
    this.showOnLoad();
  }

  showOnLoad() {
    if (Cookies.get(this.cookieName) !== 'Hidden') {
      this.showBanner();
    }
  }

  hide(e) {
    e.preventDefault();
    this.hideBanner();
    this.setCookie();
  }

  hideBanner() {
    this.element.classList.remove('visible');
  }

  showBanner() {
    this.element.classList.add('visible');
  }

  setCookie() {
    if (new CookiePreferences().allowed(this.cookieCategory)) {
      Cookies.set(this.cookieName, 'Hidden');
    }
  }

  get cookieName() {
    return `GiTBetaBanner${this.nameValue}`;
  }
}
