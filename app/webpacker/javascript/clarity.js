import CookiePreferences from '../javascript/cookie_preferences';

export default class Clarity {
  constructor(id) {
    this.id = id;
  }

  init() {
    this.containerInitialized = false;

    this.initWindow();
    this.initContainer();
    this.listenForConsentChanges();
  }

  initWindow() {
    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({ originalLocation: this.originalLocation });
  }

  initContainer() {
    if (
      !this.cookiePreferences.cookieSet ||
      this.containerInitialized ||
      this.consentValue('non-functional') !== 'granted'
    ) {
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
        console.log('User consent granted');
        this.initContainer();
        window.clarity('consent');
        console.log('Clarity consent granted');
      }
    });
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
