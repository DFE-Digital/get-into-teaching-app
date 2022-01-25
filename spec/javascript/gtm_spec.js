import Gtm from 'gtm';
import Cookies from 'js-cookie';
import CookiePreferences from 'cookie_preferences';

describe('Google Tag Manager', () => {
  const mockGtag = () => {
    window.gtag = jest.fn();
  };

  const clearCookies = () => {
    Cookies.remove(CookiePreferences.cookieName);
  };

  const setupHtml = () => {
    document.body.innerHTML = '<script></script>';
  };

  const run = () => {
    const gtm = new Gtm('ABC-123');
    gtm.init();
  };

  const mockWindowLocation = () => {
    Object.defineProperty(window, 'location', {
      configurable: true,
      value: {
        protocol: 'https',
        hostname: 'localhost',
        pathname: '/path',
        search: '?utm=tag',
      },
    });
  };

  beforeEach(() => {
    mockWindowLocation();
    clearCookies();
    setupHtml();
  });

  describe('initialisation', () => {
    beforeEach(() => {
      run();
    });

    it('defines window.dataLayer', () => {
      expect(window.gtag).toBeDefined();
    });

    it('defines window.gtag', () => {
      expect(window.dataLayer).toBeDefined();
    });

    it('pushes the original location onto the dataLayer', () => {
      expect(window.dataLayer).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            originalLocation: 'https://localhost/path?utm=tag',
          }),
        ])
      );
    });

    it('appends the GTM script', () => {
      const scriptTag = document.querySelector(
        "script[src^='https://www.googletagmanager.com/gtm.js?id=ABC-123']"
      );
      expect(scriptTag).not.toBeNull();
    });
  });

  describe('on Turbolinks page changes', () => {
    beforeEach(() => {
      mockGtag();
      run();
    });

    it('updates the page_path in GTM', () => {
      window.location.pathname = '/new-path';

      // We receive a turbolinks:load call on the initial (non-turbolinks) page load.
      document.dispatchEvent(new Event('turbolinks:load'));

      expect(window.gtag).toHaveBeenCalledWith('set', 'page_path', '/new-path');
      expect(window.gtag).toHaveBeenCalledWith('event', 'page_view');
    });
  });

  describe('when cookies have not yet been accepted', () => {
    beforeEach(() => {
      mockGtag();
      run();
    });

    it('sends GTM defaults with all cookies denied', () => {
      expect(window.gtag).toHaveBeenCalledWith('consent', 'default', {
        analytics_storage: 'denied',
        ad_storage: 'denied',
      });
    });

    describe('when cookies are accepted', () => {
      it('updates GTM of all cookie preferences', () => {
        new CookiePreferences().setCategories({ marketing: true });
        expect(window.gtag).toHaveBeenCalledWith('consent', 'update', {
          analytics_storage: 'denied',
          ad_storage: 'granted',
        });
      });
    });
  });

  describe('when cookies have already been accepted', () => {
    beforeEach(() => {
      new CookiePreferences().setCategories({ 'non-functional': true });
      mockGtag();
      run();
    });

    it('sends GTM defaults with all cookie preferences', () => {
      expect(window.gtag).toHaveBeenCalledWith('consent', 'default', {
        analytics_storage: 'granted',
        ad_storage: 'denied',
      });
    });
  });
});
