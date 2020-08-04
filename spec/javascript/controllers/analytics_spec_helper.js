import { Application } from 'stimulus' ;

export default class {
  static setCookie(cookieContent) {
    Object.defineProperty(window.document, 'cookie', {
      writable: true,
      value: cookieContent
    })
  }

  static setAcceptedCookie() {
    const nextYear = (new Date).getFullYear() + 1 ;
    this.setCookie('GiTBetaCookie=Accepted; expires=Fri, 31 Dec ' + nextYear + ' 12:00:00 UTC') ;
  }

  static setBlankCookie() {
    this.setCookie('') ;
  }

  static initApp(name, controller, serviceId) {
    document.body.setAttribute("data-analytics-" + name + "-id", serviceId) ;
    const application = Application.start() ;
    application.register(name, controller) ;
  }

  static describeWithCookieSet(name, controller, serviceFunctionName) {
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

  static describeWhenEventFires(name, controller, serviceFunctionName) {
    describe("without cookie set yet", () => {
      beforeEach(() => {
        this.setBlankCookie() ;
        this.initApp(name, controller, "1234") ;
      })

      it("Should not register the service", () => {
        expect(typeof(window[serviceFunctionName])).toBe("undefined") ;
      }) ;

      it("Should register service when event is emitted", () => {
        document.dispatchEvent(new Event("cookies:accepted")) ;
        expect(typeof(window[serviceFunctionName])).toBe("function") ;
      }) ;
    }) ;
  }
}
