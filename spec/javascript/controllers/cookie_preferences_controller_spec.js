import { Application } from 'stimulus' ;
import CookiePreferencesController from 'cookie_preferences_controller.js' ;

const Cookies = require('js-cookie') ;
import CookiePreferences from 'cookie_preferences' ;

describe('CookiePreferencesController', () => {
  document.body.innerHTML =
  `<form data-controller="cookie-preferences">
    <fieldset data-target="cookie-preferences.category" data-category="first">
      <input type="radio" value="0" id="first-no" name="cookies-first" data-action="cookie-preferences#toggle" />
      <input type="radio" value="1" id="first-yes" name="cookies-first" data-action="cookie-preferences#toggle" />
    </fieldset>

    <fieldset data-target="cookie-preferences.category" data-category="second">
      <input type="radio" value="0" id="second-no" name="cookies-second" data-action="cookie-preferences#toggle" />
      <input type="radio" value="1" id="second-yes" name="cookies-second" data-action="cookie-preferences#toggle" />
    </fieldset>
  </form>` ;

  function getCookie() {
    return Cookies.get(CookiePreferences.cookieName) ;
  }

  function setCookie(content) {
    Cookies.set(CookiePreferences.cookieName, content) ;
  }

  function getJsonCookie() {
    return JSON.parse(getCookie()) ;
  }

  function setJsonCookie(data) {
    setCookie(JSON.stringify(data)) ;
  }

  beforeEach(() => {
    setJsonCookie({ first: true, second: false })

    const application = Application.start() ;
    application.register('cookie-preferences', CookiePreferencesController);
  })

  describe("on page load", () => {
    it('radios should be assigned', () => {
      expect(document.getElementById('first-yes').checked).toBe(true) ;
      expect(document.getElementById('first-no').checked).toBe(false) ;
      expect(document.getElementById('second-yes').checked).toBe(false) ;
      expect(document.getElementById('second-no').checked).toBe(true) ;
    })
  }) ;

  describe("when changing radios", () => {
    it("cookie should be updated", () => {
      expect(getJsonCookie()).toEqual({ first: true, second: false })
      document.getElementById('first-no').click() ;
      expect(getJsonCookie()).toEqual({ first: false, second: false })
      document.getElementById('second-yes').click() ;
      expect(getJsonCookie()).toEqual({ first: false, second: true })
    })
  }) ;
}) ;
