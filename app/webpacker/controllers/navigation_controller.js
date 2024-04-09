import { Controller } from '@hotwired/stimulus';

const menuSelectors =
  'ol.category-links-list, ol.page-links-list, ol.category-navigation, ol.page-navigation';

export default class extends Controller {
  static targets = ['primary', 'nav', 'menu', 'desktop'];

  connect() {}

  // toggles the entire nav on tablet/mobile
  toggleNav(event) {
    // fires when the user clicks on the "Menu" button (not a menu item)
    event.preventDefault();
    event.stopPropagation();

    const nav = this.navTarget;

    if (nav.classList.contains(this.navHiddenClass)) {
      this.expandNav();
      this.menuToggler.ariaExpanded = 'true';
    } else {
      this.collapseNav();
      this.menuToggler.ariaExpanded = 'false';
    }
  }

  toggleNavMenuItem(event) {
    // fires when the user clicks on a navigation menu item
    const self = this;
    const ol = event.target.closest('ol');
    const li = event.target.closest('li');
    const selectedIcon = li.querySelector('span.nav-icon');
    const selectors = ol.dataset.selectors || menuSelectors;
    const toggleIds = li.dataset.toggleIds || [];

    [].forEach.call(
      this.navTarget.querySelectorAll('span.nav-icon'),
      function (icon) {
        if (icon === selectedIcon) {
          if (self.toggleIconUp(icon)) {
            if (!(li.dataset.directLink === 'true')) {
              event.preventDefault();
              event.stopPropagation();
              self.showMenu(toggleIds.split(' '), selectors);
              li.querySelector('a').ariaExpanded = true;
            }
          } else {
            event.preventDefault();
            event.stopPropagation();
            self.toggleIconDown(icon);
            self.hideMenu(selectors);
            li.querySelector('a').ariaExpanded = false;
          }
        } else {
          self.toggleIconDown(icon);
          icon.closest('li').querySelector('a').ariaExpanded = false;
        }
      }
    );
  }

  toggleIconUp(icon) {
    if (icon && icon.classList.contains('nav-icon__arrow-down')) {
      icon.classList.remove('nav-icon__arrow-down');
      icon.classList.add('nav-icon__arrow-up');
      return true;
    }
    return false;
  }

  toggleIconDown(icon) {
    if (icon && icon.classList.contains('nav-icon__arrow-up')) {
      icon.classList.remove('nav-icon__arrow-up');
      icon.classList.add('nav-icon__arrow-down');
      return true;
    }
    return false;
  }

  showMenu(toggleIds, selectors) {
    [].forEach.call(
      this.navTarget.querySelectorAll(selectors),
      function (child) {
        if (
          toggleIds.includes(child.id) &&
          child.classList.contains('hidden-menu')
        ) {
          child.classList.remove('hidden-menu');
        } else if (
          !toggleIds.includes(child.id) &&
          !child.classList.contains('hidden-menu')
        ) {
          child.classList.add('hidden-menu');
        }
      }
    );
  }

  hideMenu(selectors) {
    [].forEach.call(
      this.navTarget.querySelectorAll(selectors),
      function (child) {
        if (!child.classList.contains('hidden-menu')) {
          child.classList.add('hidden-menu');
        }
      }
    );
  }

  collapseMenu(menu, item) {
    menu.classList.add(this.menuHiddenClass);

    item.classList.remove('down');
    item.classList.add('up');
  }

  expandMenu(menu, item) {
    this.collapseAllOpenMenus();
    menu.classList.remove(this.menuHiddenClass);

    item.classList.remove('up');
    item.classList.add('down');
  }

  collapseAllOpenMenus() {
    this.primaryTarget.querySelectorAll('li.menu.down').forEach((li) => {
      const menu = li.querySelector('ol.secondary');

      if (menu && li) {
        this.collapseMenu(menu, li);
      }
    });
  }

  collapseNav() {
    this.menuTarget.classList.remove('open');
    this.navTarget.classList.add(this.navHiddenClass);
  }

  expandNav() {
    this.menuTarget.classList.add('open');
    this.navTarget.classList.remove(this.navHiddenClass);
  }

  get menuHiddenClass() {
    return 'hidden';
  }

  get navHiddenClass() {
    return 'hidden-mobile';
  }

  get menuToggler() {
    return document.getElementById('menu-toggle');
  }
}
