import CookiePreferences from '../javascript/cookie_preferences';

export default class GoogleOptimize {
  static cookieCategory = 'non-functional';

  constructor(id, paths) {
    this.id = id;
    this.paths = paths;
  }

  init() {
    this.applyRedirectExperimentFix();

    if (this.canExperiment()) {
      this.initGoogleOptimize();
    }

    this.listenForTurboBeforeVisit();
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
      'turbo:before-visit',
      this.turboBeforeVisitHandler
    );
  }

  applyRedirectExperimentFix() {
    // Google Optimize drops a cookie for 5 seconds that prevents it redirecting
    // again. This is designed to avoid redirect loops, however it means if a user
    // navigates to a redirect experiment twice in quick succession they don't get
    // redirected the second time (and can end up seeing the control instead of the
    // variant). Manually removing this cookie prevents that happening, but will
    // leave us vulnerable to redirect loops if we don't set up experiments correctly;
    // as we run few experiments this seems like the lesser of two evils.
    CookiePreferences.clearCookie('_gaexp_rc');
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

  handleTurboBeforeVisit(event) {
    const path = new URL(event.data.url).pathname;

    if (this.canExperiment(path)) {
      // Cancel Turbo page change.
      event.preventDefault();
      // Force a full page reload to initialize the optimize script
      // and serve the correct variant.
      window.location.href = event.data.url;
    }
  }

  listenForTurboBeforeVisit() {
    this.turboBeforeVisitHandler = this.handleTurboBeforeVisit.bind(this);
    document.addEventListener(
      'turbo:before-visit',
      this.turboBeforeVisitHandler
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
