import CookiePreferences from '../javascript/cookie_preferences';

export default class Gtm {
  constructor(id) {
    this.id = id;
  }

  init() {
    this.firstLoad = true;

    this.initWindow();
    this.sendDefaultConsent();
    this.initContainer();
    this.listenForConsentChanges();
    this.listenForHistoryChange();
  }

  initWindow() {
    window.dataLayer = window.dataLayer || [];

    // We use this to retain Google Ads tracking parameters in the
    // URL of the landing page (or they are subsequently lost when
    // Turbo transitions).
    window.dataLayer.push({ originalLocation: this.originalLocation });

    function gtag() {
      window.dataLayer.push(arguments);
    }

    window.gtag = window.gtag || gtag;
  }

  initContainer() {
    (function (w, d, s, l, i) {
      w[l] = w[l] || [];
      w[l].push({ 'gtm.start': new Date().getTime(), event: 'gtm.js' });
      const f = d.getElementsByTagName(s)[0];
      const j = d.createElement(s);
      const dl = l !== 'dataLayer' ? '&l=' + l : '';
      j.async = true;
      j.src = 'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
      f.parentNode.insertBefore(j, f);
    })(window, document, 'script', 'dataLayer', this.id);
  }

  listenForConsentChanges() {
    document.addEventListener('cookies:accepted', () => {
      window.gtag('consent', 'update', this.consent());
    });
  }

  listenForHistoryChange() {
    document.addEventListener('turbo:load', () => {
      // Ignore the first turbo:load call, as the GA script will
      // track that page view for us.
      if (this.firstLoad) {
        this.firstLoad = false;
        return;
      }

      window.gtag('set', 'page_path', window.location.pathname);
      window.gtag('event', 'page_view');
    });
  }

  sendDefaultConsent() {
    window.gtag('consent', 'default', this.consent());
  }

  consent() {
    return {
      analytics_storage: this.consentValue('non-functional'),
      ad_storage: this.consentValue('marketing'),
    };
  }

  consentValue(category) {
    return new CookiePreferences().allowedCategories.includes(category)
      ? 'granted'
      : 'denied';
  }

  get originalLocation() {
    const l = window.location;
    return `${l.protocol}://${l.hostname}${l.pathname}${l.search}`;
  }
}
