import { Application } from '@hotwired/stimulus';
import CookiePreferencesController from 'cookie_preferences_controller.js';
import Cookies from 'js-cookie';
import CookiePreferences from 'cookie_preferences';

describe('CookiePreferencesController', () => {
  function clearPage() {
    document.body.innerHTML = '';
  }

  function initPage() {
    document.body.innerHTML = `<form data-controller="cookie-preferences">
      <fieldset data-cookie-preferences-target="category" data-category="first">
        <input type="radio" value="0" id="first-no" name="cookies-first" data-action="cookie-preferences#toggle" />
        <input type="radio" value="1" id="first-yes" name="cookies-first" data-action="cookie-preferences#toggle" />
      </fieldset>

      <fieldset data-cookie-preferences-target="category" data-category="second">
        <input type="radio" value="0" id="second-no" name="cookies-second" data-action="cookie-preferences#toggle" />
        <input type="radio" value="1" id="second-yes" name="cookies-second" data-action="cookie-preferences#toggle" />
      </fieldset>

      <button type="submit" data-action="cookie-preferences#save">Save</save>
    </form>`;
  }

  function getCookie() {
    return Cookies.get(CookiePreferences.cookieName);
  }

  function setCookie(content) {
    Cookies.set(CookiePreferences.cookieName, content);
  }

  function getJsonCookie() {
    return JSON.parse(getCookie());
  }

  function setJsonCookie(data) {
    setCookie(JSON.stringify(data));
  }

  function initCookie() {
    setJsonCookie({ first: true, second: false });
  }

  function getState() {
    const form = document.querySelector(
      'form[data-controller="cookie-preferences"]'
    );
    return form.getAttribute('data-cookie-preferences-save-state');
  }

  const application = Application.start();
  application.register('cookie-preferences', CookiePreferencesController);

  beforeEach(clearPage);

  describe('on page load', () => {
    beforeEach(() => {
      initCookie();
      initPage();
    });

    it('radios should be assigned', () => {
      expect(document.getElementById('first-yes').checked).toBe(true);
      expect(document.getElementById('first-no').checked).toBe(false);
      expect(document.getElementById('second-yes').checked).toBe(false);
      expect(document.getElementById('second-no').checked).toBe(true);
    });
  });

  describe('on page load without cookie', () => {
    beforeEach(() => {
      initPage();
    });

    it('should save cookie', () => {
      const data = getJsonCookie();
      expect(data.functional).toBe(undefined);
    });
  });

  describe('when changing radios', () => {
    beforeEach(() => {
      initCookie();
      initPage();
    });

    it('cookie should only be updated when they click save', () => {
      expect(getJsonCookie()).toEqual({ first: true, second: false });
      document.getElementById('first-no').click();
      expect(getJsonCookie()).toEqual({ first: true, second: false });
      document.getElementById('second-yes').click();
      expect(getJsonCookie()).toEqual({ first: true, second: false });

      document.querySelector('button').click();
      expect(getJsonCookie()).toEqual({
        first: false,
        functional: true,
        second: true,
      });
    });
  });

  describe('save state', () => {
    beforeEach(() => {
      initCookie();
      initPage();
    });

    it('should change state when clicking save', () => {
      expect(getState()).toEqual(null);

      document.getElementById('first-no').click();
      expect(getState()).toEqual('unsaved');

      document.querySelector('button').click();
      expect(getState()).toEqual('saving');

      document.getElementById('second-yes').click();
      expect(getState()).toEqual('unsaved');
    });
  });
});
