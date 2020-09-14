const Cookies = require('js-cookie') ;

export default class CookiePreferences {
  static cookieBaseName = "git-cookie-preferences" ;
  static cookieVersion = 1 ;
  static cookieLifetimeInDays = 90 ;
  static allCategories = {
    'functional' : true,
    'non-functional' : true,
    'marketing' : true
  } ;

  settings = null ;
  cookieSet = false ;

  constructor() {
    this.readCookie() ;
  }

  static get cookieName() {
    return CookiePreferences.cookieBaseName + "-v" + CookiePreferences.cookieVersion ;
  }

  readCookie() {
    const cookie = Cookies.get(CookiePreferences.cookieName);
    if (typeof(cookie) == 'undefined' || !cookie) {
      this.settings = {} ;
    } else {
      this.settings = JSON.parse(cookie) ;
      this.cookieSet = true ;
    }
  }

  writeCookie(categories) {
    const serialized = JSON.stringify(categories)
    Cookies.set(CookiePreferences.cookieName, serialized, {
      expires: CookiePreferences.cookieLifetimeInDays
    }) ;

    this.cookieSet = true ;
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
    const existingAllowed = this.allowedCategories ;

    this.writeCookie(categories) ;
    this.readCookie() ;

    const newlyAllowed = this.allowedCategories.filter(category => !existingAllowed.includes(category))

    this.emitEvent(newlyAllowed) ;
  }

  setCategory(category, value) {
    const strValue = value.toString() ;
    const boolValue =
      (strValue == "1" || strValue == "true" || strValue == "yes") ;

    let newSettings = Object.assign({}, this.settings) ;
    newSettings[category] = boolValue ;

    this.all = newSettings ;
  }

  get allowedCategories() {
    return this.categories.filter(category => this.allowed(category))
  }

  emitEvent(newCategories) {
    let acceptedCookies = new CustomEvent("cookies:accepted", {
      detail: { cookies: newCategories }
    }) ;

    document.dispatchEvent(acceptedCookies) ;
  }

  allowAll() {
    this.all = CookiePreferences.allCategories ;
  }
}
