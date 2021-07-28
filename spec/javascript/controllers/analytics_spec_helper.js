import Cookies from 'js-cookie';
import CookiePreferences from 'cookie_preferences';
import { Application } from 'stimulus';

export default class {
  static setCookie(cookieContent) {
    Cookies.set(CookiePreferences.cookieName, cookieContent);
  }

  static setAcceptedCookie() {
    new CookiePreferences().allowAll();
  }

  static setBlankCookie() {
    this.setCookie('');
  }

  static vwoCompletes() {
    window.willRedirectionOccurByVWO = false;
    document.dispatchEvent(new CustomEvent('vwo:completed'));
  }

  static vwoCompletesAndRedirects() {
    window.willRedirectionOccurByVWO = true;
    document.dispatchEvent(new CustomEvent('vwo:completed'));
  }

  static initApp(name, controller, serviceId) {
    document.body.setAttribute('data-analytics-' + name + '-id', serviceId);
    const application = Application.start();
    application.register(name, controller);
  }

  static describeWithCookieSet(name, controller, serviceFunctionName) {
    beforeEach(() => {
      window._vwo_code = {};
    });

    describe('with cookie already set', () => {
      beforeEach(() => {
        delete window.willRedirectionOccurByVWO;
        Cookies.remove(CookiePreferences.cookieName);
      });

      describe('When VWO has completed', () => {
        beforeEach(() => {
          window.willRedirectionOccurByVWO = false;
          this.setAcceptedCookie();
        });

        describe('with no service id', () => {
          beforeEach(() => {
            this.initApp(name, controller, '');
          });

          it('Should not register the service', () => {
            expect(typeof window[serviceFunctionName]).toBe('undefined');
          });
        });

        describe('with service id set', () => {
          beforeEach(() => {
            this.initApp(name, controller, '1234');
          });

          it('Should register the service', () => {
            expect(typeof window[serviceFunctionName]).toBe('function');
          });
        });

        describe('with VWO disabled', () => {
          beforeEach(() => {
            delete window._vwo_code;
            delete window.willRedirectionOccurByVWO;
          });

          describe('with no service id', () => {
            beforeEach(() => {
              this.initApp(name, controller, '');
            });

            it('Should not register the service', () => {
              expect(typeof window[serviceFunctionName]).toBe('undefined');
            });
          });

          describe('with service id set', () => {
            beforeEach(() => {
              this.initApp(name, controller, '1234');
            });

            it('Should register the service', () => {
              expect(typeof window[serviceFunctionName]).toBe('function');
            });
          });
        });
      });

      describe('When VWO has completed but is navigating away', () => {
        beforeEach(() => {
          window.willRedirectionOccurByVWO = true;
          this.initApp(name, controller, '1234');
        });

        it('Should not register the service', () => {
          expect(typeof window[serviceFunctionName]).toBe('undefined');
        });
      });

      describe('VWO has not yet completed', () => {
        beforeEach(() => {
          this.setAcceptedCookie();
          this.initApp(name, controller, '1234');
        });

        describe('with service id set', () => {
          it('Should not register the service', () => {
            expect(typeof window[serviceFunctionName]).toBe('undefined');
          });
        });

        describe('Than VWO completes', () => {
          it('Should now register the service', () => {
            this.vwoCompletes();
            expect(typeof window[serviceFunctionName]).toBe('function');
          });
        });

        describe('Than VWO completes but is navigating away', () => {
          it('Should now register the service', () => {
            this.vwoCompletesAndRedirects();
            expect(typeof window[serviceFunctionName]).toBe('undefined');
          });
        });
      });
    });
  }

  static describeWhenEventFires(
    name,
    controller,
    serviceFunctionName,
    cookieCategory
  ) {
    beforeEach(() => {
      window._vwo_code = {};
    });

    describe('with VWO disabled', () => {
      beforeEach(() => {
        delete window._vwo_code;
        delete window.willRedirectionOccurByVWO;
        Cookies.remove(CookiePreferences.cookieName);
        this.initApp(name, controller, '1234');
      });

      it('should not register the service', () => {
        expect(typeof window[serviceFunctionName]).toBe('undefined');
      });

      describe('than cookies are accepted', () => {
        it('should register service', () => {
          new CookiePreferences().setCategory(cookieCategory, true);
          expect(typeof window[serviceFunctionName]).toBe('function');
        });
      });
    });

    describe('when cookies have not yet been accepted', () => {
      beforeEach(() => {
        delete window.willRedirectionOccurByVWO;
        Cookies.remove(CookiePreferences.cookieName);
        this.initApp(name, controller, '1234');
      });

      describe('than VWO completes', () => {
        beforeEach(() => {
          window.willRedirectionOccurByVWO = false;
        });

        it('should not register the service', () => {
          expect(typeof window[serviceFunctionName]).toBe('undefined');
        });

        describe('than cookies are accepted', () => {
          it('should register service', () => {
            new CookiePreferences().setCategory(cookieCategory, true);
            expect(typeof window[serviceFunctionName]).toBe('function');
          });
        });
      });

      describe('VWO has not yet completed', () => {
        describe('then the cookie event is emitted', () => {
          it('Should not register the service when', () => {
            new CookiePreferences().setCategory(cookieCategory, true);
            expect(typeof window[serviceFunctionName]).toBe('undefined');
          });
        });

        describe('VWO then completes and emits event', () => {
          it('should register the service', () => {
            new CookiePreferences().setCategory(cookieCategory, true);
            expect(typeof window[serviceFunctionName]).toBe('undefined');

            this.vwoCompletes();
            expect(typeof window[serviceFunctionName]).toBe('function');
          });
        });

        describe('VWO then completes but is navigating away', () => {
          it('should not register the service', () => {
            new CookiePreferences().setCategory(cookieCategory, true);
            expect(typeof window[serviceFunctionName]).toBe('undefined');

            this.vwoCompletesAndRedirects();
            expect(typeof window[serviceFunctionName]).toBe('undefined');
          });
        });
      });
    });
  }
}
