const Cookies = require('js-cookie');
import { Application } from 'stimulus';
import CookieAcceptanceController from 'cookie-acceptance_controller.js';

describe('CookieAcceptanceController', () => {
  let cookieName = 'git-cookie-preferences-v1';

  document.body.innerHTML = `<div data-controller="cookie-acceptance">
        <div id="overlay" class="cookie-acceptance" data-cookie-acceptance-target="overlay">
            <div class="cookie-acceptance__background"></div>
            <div class="cookie-acceptance__dialog">
                <div class="cookie-acceptance__dialog__header">
                    Header
                </div>
                BODY
                <a href="#" id="cookies-agree" data-cookie-acceptance-target="agree" class="call-to-action-button" data-action="click->cookie-acceptance#accept">
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
      let overlay = document.getElementById('overlay');
      expect(overlay.style.display).toBe('');
    });
  });

  describe('when the cookie is not set', () => {
    beforeEach(() => {
      initApp();
    });

    it('shows the cookie acceptance dialog', () => {
      let overlay = document.getElementById('overlay');
      expect(overlay.style.display).toBe('flex');
    });
  });

  describe('clicking the accept button', () => {
    beforeEach(() => {
      initApp();

      let acceptanceButton = document.getElementById('cookies-agree');
      acceptanceButton.click();
    });

    it('sets the cookie', () => {
      expect(Cookies.get('git-cookie-preferences-v1')).not.toBe(false);
    });

    it('hides the dialog', () => {
      let overlay = document.getElementById('overlay');
      expect(overlay.style.display).toBe('none');
    });
  });
});
