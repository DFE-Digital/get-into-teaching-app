import Cookies from 'js-cookie';
import { Application } from 'stimulus';
import CookieAcceptanceController from 'cookie-acceptance_controller.js';

describe('CookieAcceptanceController', () => {
  document.body.innerHTML = `<div data-controller="cookie-acceptance">
        <div id="overlay" class="cookie-acceptance" data-cookie-acceptance-target="overlay">
            <a class="cookies-info" href="#" data-cookie-acceptance-target="info">some-link</a>
            <div class="cookie-acceptance__background"></div>
            <div class="cookie-acceptance__dialog">
                <div class="cookie-acceptance__dialog__header">
                    Header
                </div>
                BODY
                <a href="#" id="biscuits-agree" data-cookie-acceptance-target="agree" class="call-to-action-button" data-action="click->cookie-acceptance#accept">
                    Yes, I agree. Continue to the new <span>website</span>
                </a>
                <a class="secondary-link" href='https://getintoteaching.education.gov.uk/' data-cookie-acceptance-target="disagree" id="cookies-disagree">
                  No, I want to go to the current website <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </div>
    </div>`;

  function initApp() {
    const application = Application.start();
    application.register('cookie-acceptance', CookieAcceptanceController);
  }

  beforeEach(() => {
    Cookies.remove('git-cookie-preferences-v1');
  });

  describe('when the cookie is set', () => {
    beforeEach(() => {
      const data = JSON.stringify({ functional: true });
      Cookies.set('git-cookie-preferences-v1', data);

      initApp();
    });

    it('does not show the cookie acceptance dialog', () => {
      const overlay = document.getElementById('overlay');
      expect(overlay.classList.contains('visible')).toBe(false);
    });
  });

  describe('when the cookie is not set', () => {
    beforeEach(() => {
      initApp();
    });

    it('shows the cookie acceptance dialog', () => {
      const overlay = document.getElementById('overlay');
      expect(overlay.classList.contains('visible')).toBe(true);
    });
  });

  describe('clicking the accept button', () => {
    beforeEach(() => {
      initApp();

      const acceptanceButton = document.getElementById('biscuits-agree');
      acceptanceButton.click();
    });

    it('sets the cookie', () => {
      expect(Cookies.get('git-cookie-preferences-v1')).not.toBe(false);
    });

    it('hides the dialog', () => {
      const overlay = document.getElementById('overlay');
      expect(overlay.classList.contains('visible')).toBe(false);
    });
  });
});
