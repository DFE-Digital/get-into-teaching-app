import Cookies from 'js-cookie';
import { Application } from 'stimulus';
import CookieAcceptanceController from 'cookie-acceptance_controller.js';

describe('CookieAcceptanceController', () => {
  let acceptButton;
  let infoButton;
  let disagreeButton;

  document.body.innerHTML = `<div data-controller="cookie-acceptance">
        <div id="overlay" class="cookie-acceptance" data-cookie-acceptance-target="overlay">
            <a tabindex="-1" class="cookies-info" href="#" data-cookie-acceptance-target="info">some-link</a>
            <div class="cookie-acceptance__background"></div>
            <div class="cookie-acceptance__dialog">
                <div class="cookie-acceptance__dialog__header">
                    Header
                </div>
                BODY
                <a tabindex="-1" href="#" id="biscuits-agree" data-cookie-acceptance-target="agree" class="call-to-action-button" data-action="click->cookie-acceptance#accept">
                    Yes, I agree. Continue to the new <span>website</span>
                </a>
                <a tabindex="-1" class="secondary-link" href='https://getintoteaching.education.gov.uk/' data-cookie-acceptance-target="disagree" id="cookies-disagree">
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

    acceptButton = document.getElementById('biscuits-agree');
    infoButton = document.querySelector('.cookies-info');
    disagreeButton = document.getElementById('cookies-disagree');
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

    it('updates the tab indexes', () => {
      expect(acceptButton.tabIndex).toEqual(1)
      expect(infoButton.tabIndex).toEqual(2)
      expect(disagreeButton.tabIndex).toEqual(3)
    })

    describe('tabbing behaviour', () => {
      describe('when the accept button has focus', () => {
        it('tabs to the info link and from the disagree button', () => {
          acceptButton.dispatchEvent(new KeyboardEvent('keydown', { keyCode: 9 }));
          expect(infoButton).toEqual(document.activeElement);

          acceptButton.dispatchEvent(new KeyboardEvent('keydown', { keyCode: 9, shiftKey: true }));
          expect(disagreeButton).toEqual(document.activeElement);
        })
      });

      describe('when the info link has focus', () => {
        it('tabs to the disagree button and from the agree button', () => {
          infoButton.dispatchEvent(new KeyboardEvent('keydown', { keyCode: 9 }));
          expect(disagreeButton).toEqual(document.activeElement);

          infoButton.dispatchEvent(new KeyboardEvent('keydown', { keyCode: 9, shiftKey: true }));
          expect(acceptButton).toEqual(document.activeElement);
        })
      });

      describe('when the disagree link has focus', () => {
        it('tabs to the accept button and from the info button', () => {
          disagreeButton.dispatchEvent(new KeyboardEvent('keydown', { keyCode: 9 }));
          expect(acceptButton).toEqual(document.activeElement);

          disagreeButton.dispatchEvent(new KeyboardEvent('keydown', { keyCode: 9, shiftKey: true }));
          expect(infoButton).toEqual(document.activeElement);
        })
      });
    });

    describe('clicking the accept button', () => {
      beforeEach(() => {
        acceptButton.click();
      });

      it('sets the cookie', () => {
        expect(Cookies.get('git-cookie-preferences-v1')).not.toBe(false);
      });

      it('hides the dialog', () => {
        const overlay = document.getElementById('overlay');
        expect(overlay.classList.contains('visible')).toBe(false);
      });

      it('removes elements from the tab sequencing', () => {
        expect(acceptButton.tabIndex).toEqual(-1)
        expect(infoButton.tabIndex).toEqual(-1)
        expect(disagreeButton.tabIndex).toEqual(-1)
      });
    });
  });
});
