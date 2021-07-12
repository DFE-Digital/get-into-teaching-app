import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['primary', 'nav', 'menu'];

  connect() {}

  toggleMenu(event) {
    event.preventDefault();
    event.stopPropagation();

    const toggle = event.target.closest('li');
    const secondary = event.target.closest('li').querySelector('ol.secondary')


    if (secondary.classList.contains(this.menuHiddenClass)) {
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

    if (nav.classList.contains(this.navHiddenClass)) {
      this.expandNav();
    } else {
      this.collapseNav();
    }
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
}
