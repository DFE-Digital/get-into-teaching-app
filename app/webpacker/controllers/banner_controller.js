import Cookies from 'js-cookie';
import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  cookieCategory = 'functional';

  connect() {
    this.hideOnLoad();
  }

  hideOnLoad() {
    if (Cookies.get(this.cookieName) === 'Hidden') {
      this.hideBanner();
    }
  }

  hide(e) {
    e.preventDefault();
    this.hideBanner();
    this.setCookie();
  }

  hideBanner() {
    this.element.style.display = 'none';
  }

  setCookie() {
    if (new CookiePreferences().allowed(this.cookieCategory))
      Cookies.set(this.cookieName, 'Hidden');
  }

  get cookieName() {
    return `GiTBetaBanner${this.name}`;
  }

  get name() {
    return this.data.get('name');
  }
}
