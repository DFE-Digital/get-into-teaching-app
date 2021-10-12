import { Application } from 'stimulus';
import GtmConsentController from 'gtm_consent_controller';
import Cookies from 'js-cookie';
import CookiePreferences from 'cookie_preferences';

describe('GtmConsentController', () => {
  const setupHtml = () => {
    document.body.innerHTML = '<div data-controller="gtm-consent"></div>';
  }

  const mockGtag = () => {
    window.gtag = jest.fn();
  }

  const clearCookies = () => {
    Cookies.remove(CookiePreferences.cookieName)
  }

  const registerController = () => {
    const application = Application.start()
    application.register('gtm-consent', GtmConsentController)
  }

  beforeAll(() => {
    registerController()
  })

  beforeEach(() => {
    clearCookies()
    mockGtag()
  })

  describe('when cookies have not yet been accepted', () => {
    beforeEach(() => setupHtml())

    it('updates GTM with all cookies denied', () => {
      expect(window.gtag).toHaveBeenCalledWith('consent', 'update', {
        analytics_storage: 'denied',
        ad_storage: 'denied',
      });
    })

    describe('when cookies are accepted', () => {
      it('updates GTM of all cookie preferences', () => {
        new CookiePreferences().setCategory('marketing', true);
        expect(window.gtag).toHaveBeenCalledWith('consent', 'update', {
          analytics_storage: 'denied',
          ad_storage: 'granted',
        });
      })
    })
  })

  describe('when cookies have already been accepted', () => {
    beforeEach(() => {
      new CookiePreferences().setCategory('non-functional', true);
      setupHtml()
    })

    it('updates GTM of all cookie preferences', () => {
      expect(window.gtag).toHaveBeenCalledWith('consent', 'update', {
        analytics_storage: 'granted',
        ad_storage: 'denied',
      });
    })
  })
})

