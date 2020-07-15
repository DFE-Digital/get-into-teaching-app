import { Application } from 'stimulus' ;
import CookieAcceptanceController from 'cookie-acceptance_controller.js' ;

describe('CookieAcceptanceController', () => {

    Object.defineProperty(window.document, 'cookie', {
        writable: true,
        value: 'GiTBetaCookie=Accepted; expires=Fri, 31 Dec 2021 12:00:00 UTC'
    });

    document.body.innerHTML = 
    `<div data-controller="cookie-acceptance">
        <div id="overlay" class="cookie-acceptance" data-target="cookie-acceptance.overlay">
            <div class="cookie-acceptance__background"></div>
            <div class="cookie-acceptance__dialog">
                <div class="cookie-acceptance__dialog__header">
                    Header
                </div>
                BODY
                <a href="#" id="accept-cookie" class="call-to-action-button" data-action="click->cookie-acceptance#accept">
                    Yes, I agree. Continue to the new <span>website</span>
                </a>
            </div>
        </div>
    </div>`;

    const application = Application.start() ;
    application.register('cookie-acceptance', CookieAcceptanceController);

    describe("when the cookie is set", () => {
        it('does not show the cookie acceptance dialog', () => {
            let overlay = document.getElementById('overlay');
            expect(overlay.style.display).toBe("");
        })
    });

    describe("when the cookie is not set", () => {
        it('shows the cookie acceptance dialog', () => {
            window.document.cookie = "";
            application.register('cookie-acceptance', CookieAcceptanceController);
            let overlay = document.getElementById('overlay');
            expect(overlay.style.display).toBe("flex");
        })
    });

    describe("clicking the accept button", () => {
        it('sets the cookie', () => {
            let acceptanceButton = document.getElementById("accept-cookie");
            acceptanceButton.click();
            expect(document.cookie.indexOf('GiTBetaCookie=Accepted') === -1).toBe(false);
        })
    });

    describe("clicking the accept button", () => {
        it('hides the dialog', () => {
            window.document.cookie = "";
            application.register('cookie-acceptance', CookieAcceptanceController);
            let acceptanceButton = document.getElementById("accept-cookie");
            acceptanceButton.click();
            let overlay = document.getElementById('overlay');
            expect(overlay.style.display).toBe("none");
        })
    });

});