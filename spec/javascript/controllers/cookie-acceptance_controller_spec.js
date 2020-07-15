import { Application } from 'stimulus' ;
import CookieAcceptanceController from 'cookie-acceptance_controller.js' ;

describe('CookieAcceptanceController', () => {

    document.body.innerHTML = 
    `<div data-controller="cookie-acceptance">
        <div class="cookie-acceptance" data-target="cookie-acceptance.overlay">
            <div class="cookie-acceptance__background"></div>
            <div class="cookie-acceptance__dialog">
                <div class="cookie-acceptance__dialog__header">
                    Header
                </div>
                BODY
            </div>
        </div>
    </div>`;

    describe("when no cookie is set", () => {
        it('shows the cookie acceptance dialog', () => {
            
        })
    });
});