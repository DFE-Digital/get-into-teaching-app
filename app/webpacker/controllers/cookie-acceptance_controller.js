import CookiePreferences from '../javascript/cookie_preferences';
import { Controller } from '@hotwired/stimulus';

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
    this.retrainQueryStringOnDisagree();
  }

  accept(event) {
    event.preventDefault();

    const cookiePrefs = new CookiePreferences();
    cookiePrefs.allowAll();

    this.stopInterceptingTabKeydown();
    this.overlayTarget.classList.remove('visible');
    this.resetFocus();
  }

  showDialog() {
    this.overlayTarget.classList.add('visible');
    this.startInterceptingTabKeydown();
  }

  retrainQueryStringOnDisagree() {
    // In case there are tracking parameters passed through the query string
    // we want to retain then so when they go to /cookie_preferences and accept it
    // will action them correctly (otherwise they are lost on the page change).
    const existingParams = new URLSearchParams(window.location.search);
    const url = new URL(this.disagreeTarget.href);

    existingParams.forEach((value, key) => {
      url.searchParams.set(key, value);
    });

    this.disagreeTarget.href = url.pathname + url.search;
  }

  resetFocus() {
    // focus then blur on the first link to prevent
    // the next element being tabbed to after accepting
    // being in the footer (which is where the cookie acceptance
    // HTML is placed). A small delay is required or Chromevox
    // misses the re-focus and heads to the footer.
    setTimeout(() => {
      document.querySelector('a').focus();
      document.querySelector('a').blur();
    }, 150);
  }

  startInterceptingTabKeydown() {
    // by default these have a -1 tab index which
    // prevents the keydown event triggering on tab
    this.infoTarget.tabIndex = 1;
    this.agreeTarget.tabIndex = 2;
    this.disagreeTarget.tabIndex = 3;

    this.keydownHandler = this.handleKeydown.bind(this);
    this.agreeTarget.addEventListener('keydown', this.keydownHandler);
    this.infoTarget.addEventListener('keydown', this.keydownHandler);
    this.disagreeTarget.addEventListener('keydown', this.keydownHandler);

    // focus on info target to begin with; a small delay is required
    // or Chromevox misses the focus call.
    setTimeout(() => {
      this.infoTarget.focus();
    }, 150);
  }

  stopInterceptingTabKeydown() {
    this.agreeTarget.removeEventListener('keydown', this.keydownHandler);
    this.infoTarget.removeEventListener('keydown', this.keydownHandler);
    this.disagreeTarget.removeEventListener('keydown', this.keydownHandler);

    // revert to -1 to ensure tabbing ignores these elements
    this.agreeTarget.tabIndex = -1;
    this.infoTarget.tabIndex = -1;
    this.disagreeTarget.tabIndex = -1;
  }

  // agree button is focussed on the first tab
  // cookies (link) on the second
  // disagree button on the third
  // back to agree on the fourth, and so on
  handleKeydown(e) {
    const tabKey = 9;

    if (e.keyCode === tabKey) {
      e.preventDefault();
      e.shiftKey ? this.focusOnPrevious(e) : this.focusOnNext(e);
    }
  }

  focusOnNext(e) {
    switch (e.target) {
      case this.agreeTarget:
        this.disagreeTarget.focus();
        break;
      case this.infoTarget:
        this.agreeTarget.focus();
        break;
      default:
        this.infoTarget.focus();
    }
  }

  focusOnPrevious(e) {
    switch (e.target) {
      case this.agreeTarget:
        this.infoTarget.focus();
        break;
      case this.disagreeTarget:
        this.agreeTarget.focus();
        break;
      default:
        this.disagreeTarget.focus();
    }
  }

  isPrivacyPage() {
    const path = window.location.pathname;
    const cookiesPages = ['/cookie_preference', '/cookies', '/privacy-policy'];

    return cookiesPages.includes(path);
  }
}
