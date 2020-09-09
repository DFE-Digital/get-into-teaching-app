const Cookies = require('js-cookie') ;

export default class CookiePreferences {
  static cookieBaseName = "git-cookie-preferences" ;
  static cookieVersion = 1 ;
  static cookieLifetimeInDays = 90 ;

  settings = null ;

  constructor() {
    this.settings = this.parseSettings() ;
  }

  static get cookieName() {
    return CookiePreferences.cookieBaseName + "-v" + CookiePreferences.cookieVersion ;
  }

  parseSettings() {
    const cookie = Cookies.get(CookiePreferences.cookieName);
    if (typeof(cookie) == 'undefined' || !cookie)
      return {} ;

    return JSON.parse(cookie) ;
  }

  get all() {
    return this.settings ;
  }

  allowed(category) {
    return this.settings[category] || false ;
  }

  get categories() {
    if (this.settings)
      return Object.keys(this.settings) ;
    else
      return new Array ;
  }

  set all(categories) {
    const serialized = JSON.stringify(categories)
    Cookies.set(CookiePreferences.cookieName, serialized, {
      expires: CookiePreferences.cookieLifetimeInDays
    }) ;

    this.settings = this.parseSettings() ;
  }
}
