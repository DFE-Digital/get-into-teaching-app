import CookiePreferences from '../javascript/cookie_preferences';

export default class GoogleOptimize {
  static cookieCategory = 'non-functional';

  constructor(id, paths) {
    this.id = id;
    this.paths = paths;
  }

  init() {
    if (this.canExperiment()) {
      this.initGoogleOptimize();
    }

    this.listenForTurbolinksBeforeVisit();
    this.listenForConsentChange();

    if (!this.seenCookieDialog && this.isExperimentPath()) {
      this.blurContentHandler = this.blurContent.bind(this);
      document.addEventListener('DOMContentLoaded', this.blurContentHandler);
    }
  }

  dispose() {
    if (this.blurContentHandler) {
      document.removeEventListener('DOMContentLoaded', this.blurContentHandler);
    }

    if (this.antiFlickerHandler) {
      document.removeEventListener('DOMContentLoaded', this.antiFlickerHandler);
    }

    document.removeEventListener(
      'cookies:accepted',
      this.cookieAcceptedHandler
    );

    document.removeEventListener(
      'turbolinks:before-visit',
      this.turbolinksBeforeVisitHandler
    );
  }

  initGoogleOptimize() {
    if (this.hasScript) {
      return;
    }

    this.deployAntiFlicker(() => {
      this.appendScript(() => {
        this.removeAntiFlicker();
      });
    });
  }

  appendScript(complete) {
    const fallback = setTimeout(() => {
      complete();
    }, 1000);

    const script = document.createElement('script');
    script.src = `https://www.googleoptimize.com/optimize.js?id=${this.id}`;
    script.onload = () => {
      clearTimeout(fallback);
      complete();
    };
    document.head.appendChild(script);
  }

  removeAntiFlicker() {
    document.body.classList.remove('anti-flicker');
  }

  deployAntiFlicker(complete) {
    this.antiFlickerHandler = () => {
      document.body.classList.add('anti-flicker');
      complete();
    };
    document.addEventListener('DOMContentLoaded', this.antiFlickerHandler);
  }

  blurContent() {
    // Remove the cookie dialog dark overlay.
    this.cookieDialogOverlay.remove();

    // Blur the page.
    document.body.classList.add('blur');

    // Add in our own dark overlay below the cookie dialog.
    const overlay = document.createElement('div');
    overlay.classList.add('optimize-overlay');
    document.body.append(overlay);
  }

  listenForConsentChange() {
    this.cookieAcceptedHandler = this.handleAcceptCookies.bind(this);
    document.addEventListener('cookies:accepted', this.cookieAcceptedHandler);
  }

  handleAcceptCookies() {
    if (this.canExperiment()) {
      // When we reload the optimize script will initialize and
      // the correct variant will be served.
      window.location.reload();
    }
  }

  handleTurbolinksBeforeVisit(event) {
    const path = new URL(event.data.url).pathname;

    if (this.canExperiment(path)) {
      // Cancel Turbolinks page change.
      event.preventDefault();
      // Force a full page reload to initialize the optimize script
      // and serve the correct variant.
      window.location.href = event.data.url;
    }
  }

  listenForTurbolinksBeforeVisit() {
    this.turbolinksBeforeVisitHandler =
      this.handleTurbolinksBeforeVisit.bind(this);
    document.addEventListener(
      'turbolinks:before-visit',
      this.turbolinksBeforeVisitHandler
    );
  }

  canExperiment(path = window.location.pathname) {
    return this.hasConsented && this.isExperimentPath(path);
  }

  isExperimentPath(path = window.location.pathname) {
    return this.paths.includes(path);
  }

  get hasScript() {
    return document.head.querySelector(
      'script[src^="https://www.googleoptimize.com"]'
    );
  }

  get cookieDialogOverlay() {
    return document.querySelector('.cookie-acceptance .dialog__background');
  }

  get hasConsented() {
    const category = this.constructor.cookieCategory;
    return new CookiePreferences().allowedCategories.includes(category);
  }

  get seenCookieDialog() {
    return new CookiePreferences().cookieSet;
  }
}
