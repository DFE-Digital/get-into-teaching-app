import Cookies from 'js-cookie';
import CookiePreferences from 'cookie_preferences';

describe('CookiePreferences', () => {
  let prefs = null;
  let newCategoriesEvent = null;

  function setCookie(name, content) {
    Cookies.set(name, content);
  }

  function setJsonCookie(name, data) {
    setCookie(name, JSON.stringify(data));
  }

  document.addEventListener('cookies:accepted', (event) => {
    newCategoriesEvent = event.detail.cookies;
  });

  beforeEach(() => {
    Cookies.remove(CookiePreferences.cookieName);
    newCategoriesEvent = null;
  });

  describe('cookieName', () => {
    it('should include version number', () => {
      expect(CookiePreferences.cookieName).toBe('git-cookie-preferences-v1');
    });
  });

  describe('with cookie set', () => {
    beforeEach(() => {
      setJsonCookie(CookiePreferences.cookieName, {
        required: true,
        marketing: false,
      });
      prefs = new CookiePreferences();
    });

    it('#all should load settings from cookie', () => {
      expect(prefs.all).toEqual({
        functional: true,
        required: true,
        marketing: false,
      });
    });

    it('should mark cookie as set', () => {
      expect(prefs.cookieSet).toBe(true);
    });

    describe('#allowed', () => {
      it('should return per category values', () => {
        expect(prefs.allowed('required')).toBe(true);
        expect(prefs.allowed('marketing')).toBe(false);
        expect(prefs.allowed('functional')).toBe(true);
      });

      it('should return false for unknown categories', () => {
        expect(prefs.allowed('unknown')).toBe(false);
      });
    });

    describe('#categories', () => {
      it('should return the categories held in the cookie', () => {
        expect(prefs.categories).toEqual([
          'required',
          'marketing',
          'functional',
        ]);
      });
    });

    describe('#allowedCategories', () => {
      it('should return categories set to true', () => {
        expect(prefs.allowedCategories).toEqual(['required', 'functional']);
      });
    });

    describe('#setCategories', () => {
      it('casts values to boolean', () => {
        prefs.setCategories({
          marketing: 'yes',
          test: 1,
          other: 'true',
        });

        expect(prefs.allowed('marketing')).toBe(true);
        expect(prefs.allowed('test')).toBe(true);
        expect(prefs.allowed('other')).toBe(true);

        prefs.setCategories({
          marketing: 'no',
          test: 0,
          other: 'false',
        });

        expect(prefs.allowed('marketing')).toBe(false);
        expect(prefs.allowed('test')).toBe(false);
        expect(prefs.allowed('other')).toBe(false);
      });
    });

    describe('assigning #all', () => {
      beforeEach(() => {
        prefs.all = { required: false, features: true };
      });

      it('should update', () => {
        expect(prefs.all).toEqual({
          required: false,
          features: true,
          functional: true,
        });
      });

      it('should return new values for #allowed', () => {
        expect(prefs.allowed('required')).toBe(false);
        expect(prefs.allowed('features')).toBe(true);
        expect(prefs.allowed('marketing')).toBe(false);
        expect(prefs.allowed('functional')).toBe(true);
      });

      it('should update #categories list', () => {
        expect(prefs.categories).toEqual([
          'required',
          'features',
          'functional',
        ]);
      });

      it('emits event', () => {
        expect(newCategoriesEvent).toEqual(['features']);
      });
    });

    describe('assigning existing category', () => {
      beforeEach(() => {
        prefs.setCategories({ marketing: true });
      });

      it('updates allowed value', () => {
        expect(prefs.allowed('marketing')).toBe(true);
      });

      it('updates #all', () => {
        expect(prefs.all).toEqual({
          required: true,
          marketing: true,
          functional: true,
        });
      });

      it('does not update category list', () => {
        expect(prefs.categories).toEqual([
          'required',
          'marketing',
          'functional',
        ]);
      });

      it('does update allowed categories', () => {
        expect(prefs.allowedCategories).toEqual([
          'required',
          'marketing',
          'functional',
        ]);
      });

      it('emits event', () => {
        expect(newCategoriesEvent).toEqual(['marketing']);
      });
    });

    describe('assigning functional to false', () => {
      beforeEach(() => {
        prefs.setCategories({ functional: false });
      });

      it('leaves the value as true', () => {
        expect(prefs.allowed('functional')).toBe(true);
      });

      it('is included in category list', () => {
        expect(prefs.categories.includes('functional')).toBe(true);
      });

      it('is included in the allowedCategories list', () => {
        expect(prefs.allowedCategories.includes('functional')).toBe(true);
      });
    });

    describe('assigning new category', () => {
      beforeEach(() => {
        prefs.setCategories({ features: true });
      });

      it('updates allowed value', () => {
        expect(prefs.allowed('features')).toBe(true);
      });

      it('updates #all', () => {
        expect(prefs.all).toEqual({
          required: true,
          marketing: false,
          features: true,
          functional: true,
        });
      });

      it('does not update category list', () => {
        expect(prefs.categories).toEqual([
          'required',
          'marketing',
          'functional',
          'features',
        ]);
      });

      it('does update allowed categories', () => {
        expect(prefs.allowedCategories).toEqual([
          'required',
          'functional',
          'features',
        ]);
      });

      it('emits event', () => {
        expect(newCategoriesEvent).toEqual(['features']);
      });
    });

    describe('allowAll', () => {
      beforeEach(() => {
        prefs.allowAll();
      });

      it('sets all to true', () => {
        expect(prefs.allowedCategories).toEqual([
          'functional',
          'non-functional',
          'marketing',
        ]);
      });
    });
  });

  describe('without cookie set', () => {
    beforeEach(() => {
      prefs = new CookiePreferences();
    });

    it('should mark cookie as set', () => {
      expect(prefs.cookieSet).toBe(false);
    });

    describe('#all', () => {
      it('should still include functional', () => {
        expect(prefs.all).toEqual({ functional: true });
      });
    });

    describe('#allowed', () => {
      it('should return false for all categories', () => {
        expect(prefs.allowed('functional')).toBe(true);
        expect(prefs.allowed('required')).toBe(false);
        expect(prefs.allowed('marketing')).toBe(false);
      });
    });

    describe('#categories', () => {
      it('should be functional only', () => {
        expect(prefs.categories).toEqual(['functional']);
      });
    });

    describe('#allowedCategories', () => {
      it('should be functional only', () => {
        expect(prefs.allowedCategories).toEqual(['functional']);
      });
    });

    describe('assigning #all', () => {
      beforeEach(() => {
        prefs.all = { required: false, functional: true };
      });

      it('should update', () => {
        expect(prefs.all).toEqual({ required: false, functional: true });
      });

      it('should return new values for #allowed', () => {
        expect(prefs.allowed('required')).toBe(false);
        expect(prefs.allowed('functional')).toBe(true);
        expect(prefs.allowed('marketing')).toBe(false);
      });

      it('should update #categories list', () => {
        expect(prefs.categories).toEqual(['required', 'functional']);
      });

      it('emits event', () => {
        expect(newCategoriesEvent).toEqual([]);
      });
    });

    describe('assigning new category', () => {
      beforeEach(() => {
        prefs.setCategories({ functional: true });
      });

      it('updates allowed value', () => {
        expect(prefs.allowed('functional')).toBe(true);
      });

      it('updates #all', () => {
        expect(prefs.all).toEqual({ functional: true });
      });

      it('does not update category list', () => {
        expect(prefs.categories).toEqual(['functional']);
      });

      it('emits event', () => {
        expect(newCategoriesEvent).toEqual([]);
      });
    });

    describe('opting out of a category', () => {
      beforeEach(() => {
        prefs.setCategories({ marketing: true });
      });

      it('retains essential cookies and clears non-essential cookies', () => {
        Cookies.set('non-essential', 'not essential');

        const essentialCookieKey = CookiePreferences.functionalCookies[2];
        Cookies.set(essentialCookieKey, 'essential');

        prefs.setCategories({ marketing: false });

        expect(Cookies.get('non-essential')).toBeUndefined();
        expect(Cookies.get(essentialCookieKey)).toEqual('essential');
      });
    });

    describe('allowAll', () => {
      beforeEach(() => {
        prefs.allowAll();
      });

      it('sets all to true', () => {
        expect(prefs.allowedCategories).toEqual([
          'functional',
          'non-functional',
          'marketing',
        ]);
      });
    });
  });

  describe('clearCookie', () => {
    it('clears the cookie from all domains', () => {
      Object.defineProperty(window, 'location', {
        configurable: true,
        value: new URL('https://getintoteaching.education.gov.uk/'),
      });

      const spy = jest.spyOn(Cookies, 'remove');

      CookiePreferences.clearCookie('key');

      expect(spy).toHaveBeenCalledWith('key', {
        domain: 'getintoteaching.education.gov.uk',
      });
      expect(spy).toHaveBeenCalledWith('key', {
        domain: '.getintoteaching.education.gov.uk',
      });
      expect(spy).toHaveBeenCalledWith('key', { domain: 'education.gov.uk' });
      expect(spy).toHaveBeenCalledWith('key', { domain: '.education.gov.uk' });
    });
  });
});
