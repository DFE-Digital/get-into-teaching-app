import { Application } from 'stimulus';
import NavigationController from 'navigation_controller.js';

describe('NavigationController', () => {
  document.body.innerHTML = `<div class="navbar__mobile" data-controller="navigation">
        <div class="navbar__mobile__buttons">
            <a data-action="click->navigation#navToggle" href="javascript:void(0);" class="icon">
                <div data-navigation-target="hamburger" id='hamburger' class="icon-close"></div>
                <div data-navigation-target="label" id="navbar-label" class="icon-hamburger-label">Close</div>
            </a>
        </div>
        <div data-navigation-target="links" id="navbar-mobile-links" class="navbar__mobile__links">
            <ul>
                <li><a href="/">Home</a></li>
                <li><a href="/steps-to-become-a-teacher">Steps to become a teacher</a></li>
                <li><a href="/funding-your-training">Funding your training</a></li>
                <li><a href="/life-as-a-teacher">Teaching as a career</a></li>
                <li><a href="/life-as-a-teacher/teachers-salaries-and-benefits">Salaries and Benefits</a></li>
                <li><%= link_to "Find an event near you", events_path %></li>
                <li><a href="/">Talk to us</a></li>
            </ul>
        </div>
    </div>`;

  const application = Application.start();
  application.register('navigation', NavigationController);

  describe('when first loaded', () => {
    it('hides the mobile navigation', () => {
      const themobilenav = document.getElementById('navbar-mobile-links');
      expect(themobilenav.style.display).toBe('none');
    });
  });

  describe('when first loaded', () => {
    it('sets the icon to a hamburger', () => {
      const theicon = document.getElementById('hamburger');
      expect(theicon.className).toBe('icon-hamburger');
    });
  });

  describe('when first loaded', () => {
    it("sets the label to read 'Menu'", () => {
      const thelabel = document.getElementById('navbar-label');
      expect(thelabel.innerHTML).toBe('Menu');
    });
  });

  describe('once clicked', () => {
    it('shows the mobile navigation', () => {
      const theicon = document.getElementById('hamburger');
      theicon.click();
      const themobilenav = document.getElementById('navbar-mobile-links');
      expect(themobilenav.style.display).toBe('block');
    });
  });

  describe('once clicked', () => {
    it('sets the icon to a cross', () => {
      const theicon = document.getElementById('hamburger');
      expect(theicon.className).toBe('icon-close');
    });
  });

  describe('once clicked', () => {
    it("sets the label to read 'Close'", () => {
      const thelabel = document.getElementById('navbar-label');
      expect(thelabel.innerHTML).toBe('Close');
    });
  });
});
