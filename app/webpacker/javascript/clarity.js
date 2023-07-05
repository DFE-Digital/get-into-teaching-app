import CookiePreferences from '../javascript/cookie_preferences';

export default class Clarity {
  constructor(id) {
    this.id = id;
  }

  init() {
    this.containerInitialized = false;

    this.initWindow();
    this.sendDefaultConsent();
    this.initContainer();
    this.listenForConsentChanges();
  }

  initWindow() {
    window.dataLayer = window.dataLayer || [];

    // We use this to retain Google Ads tracking parameters in the
    // URL of the landing page (or they are subsequently lost when
    // Turbolinks transitions).
    window.dataLayer.push({ originalLocation: this.originalLocation });

    function clarity() {
      window.dataLayer.push(arguments);
    }

    window.clarity = window.clarity || clarity;
  }

  initContainer() {
    if (!this.cookiePreferences.cookieSet || this.containerInitialized) {
      return;
    }

    this.containerInitialized = true;

    (function (c, l, a, r, i, t, y) {
      c[a] =
        c[a] ||
        function () {
          (c[a].q = c[a].q || []).push(arguments);
        };
      t = l.createElement(r);
      t.async = 1;
      t.src = 'https://www.clarity.ms/tag/' + i;
      y = l.getElementsByTagName(r)[0];
      y.parentNode.insertBefore(t, y);
    })(window, document, 'clarity', 'script', this.id);
  }

  listenForConsentChanges() {
    document.addEventListener('cookies:accepted', () => {
      if (this.consentValue('non-functional') === 'granted') {
        window.clarity('consent');
        this.initContainer();
      }
    });
  }

  sendDefaultConsent() {
    if (this.consentValue('non-functional') === 'granted') {
      window.clarity('consent');
    }
  }

  consent() {
    return {
      analytics_storage: this.consentValue('non-functional'),
      ad_storage: this.consentValue('marketing'),
    };
  }

  consentValue(category) {
    return this.cookiePreferences.allowedCategories.includes(category)
      ? 'granted'
      : 'denied';
  }

  get originalLocation() {
    const l = window.location;
    return `${l.protocol}://${l.hostname}${l.pathname}${l.search}`;
  }

  get cookiePreferences() {
    return new CookiePreferences();
  }
}
