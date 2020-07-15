import { Application } from 'stimulus' ;
import NavigationController from 'navigation_controller.js' ;

describe('NavigationController', () => {

    document.body.innerHTML = 
    `<div class="navbar__mobile" data-controller="navigation">
        <div class="navbar__mobile__buttons">
            <a data-action="click->navigation#navToggle" href="javascript:void(0);" class="icon">
                <div data-target="navigation.hamburger" id='hamburger' class="icon-close"></div>
                <div data-target="navigation.label" id="navbar-label" class="icon-hamburger-label">Close</div>
            </a>
        </div>
        <div data-target="navigation.links" id="navbar-mobile-links" class="navbar__mobile__links">
            <ul>
                <li><a href="/">Home</a></li>
                <li><a href="/steps-to-become-a-teacher/index">Steps to become a teacher</a></li>
                <li><a href="/funding-your-training/index">Funding your training</a></li>
                <li><a href="/life-as-a-teacher/index">Teaching as a career</a></li>
                <li><a href="/life-as-a-teacher/teachers-salaries-and-benefits">Salaries and Benefits</a></li>
                <li><%= link_to "Find an event near you", events_path %></li>
                <li><a href="/">Talk to us</a></li>
            </ul>
        </div>
    </div>`

    const application = Application.start() ;
    application.register('navigation', NavigationController) ;

    describe("when first loaded", () => {
        it("does something", () => {
        });
    });

});