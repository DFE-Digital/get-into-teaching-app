const Cookies = require('js-cookie') ;
import CookiePreferences from "cookie_preferences" ;
import { Application } from 'stimulus' ;

export default class {
  static setCookie(cookieContent) {
    Cookies.set(CookiePreferences.cookieName, cookieContent) ;
  }

  static setAcceptedCookie() {
    (new CookiePreferences).allowAll() ;
  }

  static setBlankCookie() {
    this.setCookie('') ;
  }

  static initApp(name, controller, serviceId) {
    document.body.setAttribute("data-analytics-" + name + "-id", serviceId) ;
    const application = Application.start() ;
    application.register(name, controller) ;
  }

  static describeWithCookieSet(name, controller, serviceFunctionName, cookieCategory) {
    beforeEach(() => { Cookies.remove(CookiePreferences.cookieName) })

    describe("with cookie already set", () => {
      beforeEach(() => { this.setAcceptedCookie() })

      describe("with no service id", () => {
        beforeEach(() => { this.initApp(name, controller, "") })

        it("Should not register the service", () => {
          expect(typeof(window[serviceFunctionName])).toBe("undefined") ;
        }) ;
      })

      describe("with service id set", () => {
        beforeEach(() => { this.initApp(name, controller, "1234") }) ;

        it("Should register the service", () => {
          expect(typeof(window[serviceFunctionName])).toBe("function") ;
        }) ;
      })
    })
  }

  static describeWhenEventFires(name, controller, serviceFunctionName, cookieCategory) {
    beforeEach(() => { Cookies.remove(CookiePreferences.cookieName) })

    describe("without cookie set yet", () => {
      beforeEach(() => {
        this.setBlankCookie() ;
        this.initApp(name, controller, "1234") ;
      })

      it("Should not register the service", () => {
        expect(typeof(window[serviceFunctionName])).toBe("undefined") ;
      }) ;

      it("Should register service when event is emitted", () => {
        (new CookiePreferences).setCategory(cookieCategory, true) ;
        expect(typeof(window[serviceFunctionName])).toBe("function") ;
      }) ;
    }) ;
  }
}
