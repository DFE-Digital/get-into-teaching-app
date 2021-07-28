import { Application } from 'stimulus';
import NavigationController from 'navigation_controller.js';

describe('NavigationController', () => {
  describe('opening and closing the nav menu', () => {
    document.body.innerHTML = `
    <header data-controller="navigation">
      <div class="menu-button">
        <button class="menu-button__button" data-action="click->navigation#toggleNav" data-navigation-target="menu">
          <span class="menu-button__icon"></span>
          <span class="menu-button__text">Menu</span>
        </button>
      </div>
      <nav role="nav" class="hidden-mobile" data-navigation-target="nav">
        <ol class="primary" data-navigation-target="primary">
          <li class="active">One</li>
          <li>Two</li>
          <li class="menu">
            <a class="menu__heading" data-action="click->navigation#toggleMenu" href="/what-is-teaching-like">
              <span class="menu__text">What is teaching like?</span>
              <div class="menu__chevron"></div>
            </a>
            <ol class="secondary hidden">
              <li><a href="/what-is-teaching-like/a-day-in-the-life-of-a-teacher">A day in the life of a teacher</a></li>
              <li><a href="/what-is-teaching-like/get-school-experience">Get school experience</a></li>
            </ol>
          </li>
        </ol>
      </nav>
    </header>`;

    const application = Application.start();
    application.register('navigation', NavigationController);

    it('toggles the visibility of the navigation area when menu button clicked', () => {
      expect(document.querySelector('nav').classList).toContain(
        'hidden-mobile'
      );

      document.querySelector('button').click();

      expect(document.querySelector('nav').classList).not.toContain(
        'hidden-mobile'
      );

      document.querySelector('button').click();

      expect(document.querySelector('nav').classList).toContain(
        'hidden-mobile'
      );
    });

    it('toggles the menu visability when a menu item is clicked', () => {
      const menu = document.querySelector('ol.primary > li.menu > a');
      menu.click();

      expect(document.querySelector('li.menu').classList).toContain('down');
      expect(document.querySelector('ol.secondary').classList).not.toContain(
        'hidden'
      );

      menu.click();

      expect(document.querySelector('li.menu').classList).toContain('up');
      expect(document.querySelector('ol.secondary').classList).toContain(
        'hidden'
      );
    });
  });
});
