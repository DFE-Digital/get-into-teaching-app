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

  static initApp(name, controller, serviceId) {
    document.body.setAttribute('data-analytics-' + name + '-id', serviceId);
    const application = Application.start();
    application.register(name, controller);
  }

  static describeWithCookieSet(name, controller, serviceFunctionName) {
    describe('with cookie already set', () => {
      beforeEach(() => {
        Cookies.remove(CookiePreferences.cookieName);
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
    });
  }

  static describeWhenEventFires(
    name,
    controller,
    serviceFunctionName,
    cookieCategory
  ) {

    describe('with cookies not yet set', () => {
      beforeEach(() => {
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
  }
}
