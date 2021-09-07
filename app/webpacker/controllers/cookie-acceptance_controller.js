import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['modal', 'overlay', 'agree', 'disagree', 'info'];

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

    const tabKey = 9;
    const agreeButtonID = 'biscuits-agree';
    const disagreeButtonID = 'cookies-disagree';
    const infoLinkID = 'cookies-info';

    // agree button is focussed on the first tab
    // cookies (link) on the second
    // disagree button on the third
    // back to agree on the fourth, and so on

    this.agreeTarget.addEventListener('keydown', function (e) {
      if (e.keyCode === tabKey) {
        e.preventDefault();

        if (e.shiftKey) {
          document.getElementById(disagreeButtonID).focus();
        } else {
          document.getElementById(infoLinkID).focus();
        }
      }
    });

    this.infoTarget.addEventListener('keydown', function (e) {
      if (e.keyCode === tabKey) {
        e.preventDefault();

        if (e.shiftKey) {
          document.getElementById(agreeButtonID).focus();
        } else {
          document.getElementById(disagreeButtonID).focus();
        }
      }
    });

    this.disagreeTarget.addEventListener('keydown', function (e) {
      if (e.keyCode === tabKey) {
        e.preventDefault();

        if (e.shiftKey) {
          document.getElementById(infoLinkID).focus();
        } else {
          document.getElementById(agreeButtonID).focus();
        }
      }
    });
  }

  isPrivacyPage() {
    const path = window.location.href.replace(/^https?:\/\/[^/]+/, '');
    const cookiesPages = ['/cookie_preference', '/cookies', '/privacy-policy'];

    return cookiesPages.includes(path);
  }
}
