import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['primary', 'nav'];

  connect() {}

  // toggles an individual menu on desktop
  toggleMenu(event) {
    event.preventDefault();
    event.stopPropagation();

    const toggle = event.target.parentElement;
    const secondary = event.target.parentElement.querySelector('ol');

    if (secondary.classList.contains(this.desktopHiddenClass)) {
      this.expandMenu(secondary, toggle);
    } else {
      this.collapseMenu(secondary, toggle);
    }
  }

  // toggles the entire nav on tablet/mobile
  toggleNav(event) {
    event.preventDefault();
    event.stopPropagation();

    const nav = this.navTarget;

    if (nav.classList.contains(this.mobileHiddenClass)) {
      this.expandNav();
    } else {
      this.collapseNav();
    }
  }

  collapseMenu(menu, item) {
    menu.classList.add(this.desktopHiddenClass);

    item.classList.remove('down');
    item.classList.add('up');
  }

  expandMenu(menu, item) {
    this.collapseAllOpenMenus();
    menu.classList.remove(this.desktopHiddenClass);

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
    this.navTarget.classList.add(this.mobileHiddenClass);
  }

  expandNav() {
    this.navTarget.classList.remove(this.mobileHiddenClass);
  }

  get desktopHiddenClass() {
    return 'hidden-desktop';
  }

  get mobileHiddenClass() {
    return 'hidden-mobile';
  }
}
