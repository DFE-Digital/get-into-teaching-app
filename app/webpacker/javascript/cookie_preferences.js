const Cookies = require('js-cookie');

export default class CookiePreferences {
  static cookieBaseName = 'git-cookie-preferences';
  static cookieVersion = 1;
  static cookieLifetimeInDays = 90;
  static alwaysOnCategory = 'functional';
  static allCategories = {
    functional: true,
    'non-functional': true,
    marketing: true,
  };

  static functionalCookies = [
    'git-cookie-preferences-v1',
    '_dfe_session',
    'GiTBetaBannerCovid',
  ];

  settings = null;
  cookieSet = false;

  constructor() {
    this.readCookie();
  }

  static get cookieName() {
    return (
      CookiePreferences.cookieBaseName + '-v' + CookiePreferences.cookieVersion
    );
  }

  readCookie() {
    const cookie = Cookies.get(CookiePreferences.cookieName);
    if (typeof cookie === 'undefined' || !cookie) {
      this.settings = {};
    } else {
      this.settings = JSON.parse(cookie);
      this.cookieSet = true;
    }

    this.settings[CookiePreferences.alwaysOnCategory] = true;
  }

  writeCookie(categories) {
    categories[CookiePreferences.alwaysOnCategory] = true;
    const serialized = JSON.stringify(categories);
    Cookies.set(CookiePreferences.cookieName, serialized, {
      expires: CookiePreferences.cookieLifetimeInDays,
      sameSite: 'Lax',
    });

    this.cookieSet = true;
  }

  get all() {
    return this.settings;
  }

  allowed(category) {
    return this.settings[category] || false;
  }

  get categories() {
    if (this.settings) return Object.keys(this.settings);
    else return [];
  }

  set all(categories) {
    const existingAllowed = this.allowedCategories;

    this.writeCookie(categories);
    this.readCookie();

    const newlyAllowed = this.allowedCategories.filter(
      (category) => !existingAllowed.includes(category)
    );

    this.emitEvent(newlyAllowed);
  }

  clearNonEssentialCookies() {
    Object.keys(Cookies.get()).forEach((key) => {
      if (!CookiePreferences.functionalCookies.includes(key))
        Cookies.remove(key);
    });
  }

  setCategory(category, value) {
    const strValue = value.toString();
    const boolValue =
      strValue === '1' || strValue === 'true' || strValue === 'yes';

    const newSettings = Object.assign({}, this.settings);
    const optingOut = newSettings[category] === true && !boolValue;

    if (optingOut) {
      this.clearNonEssentialCookies();
    }

    newSettings[category] = boolValue;

    this.all = newSettings;
  }

  get allowedCategories() {
    return this.categories.filter((category) => this.allowed(category));
  }

  emitEvent(newCategories) {
    const acceptedCookies = new CustomEvent('cookies:accepted', {
      detail: { cookies: newCategories },
    });

    document.dispatchEvent(acceptedCookies);
  }

  allowAll() {
    this.all = CookiePreferences.allCategories;
  }
}
