import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['primary', 'nav', 'menu', 'categories'];

  connect() {}

  // toggles the entire nav on tablet/mobile
  toggleNav(event) {
    // fires when the user clicks on the Menu button
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

  toggleMenu(event) {
    event.preventDefault();
    event.stopPropagation();

    console.log('TOGGLE MENU');
    console.log('DATASET', event.target.closest('li').dataset.id);
    console.log('OL', event.target.closest('ol').dataset);

    this.showMenu(event.target.closest('li').dataset.id, event.target.closest('ol').dataset.selectors);
  }

  showMenu(id, selectors) {
    [].forEach.call(
      this.categoriesTarget.querySelectorAll(selectors),
      function (child) {
        if (child.id === id && child.classList.contains('hidden-menu')) {
          child.classList.remove('hidden-menu');
        } else if (child.id !== id && !child.classList.contains('hidden-menu')) {
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
