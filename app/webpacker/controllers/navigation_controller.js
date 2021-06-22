import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['primary'];

  connect() {}

  toggleMenu(event) {
    event.preventDefault();
    event.stopPropagation();

    const toggle = event.target.parentElement;
    const secondary = event.target.parentElement.querySelector('ol');

    if (secondary.classList.contains('hidden')) {
      this.expandMenu(secondary, toggle);
    } else {
      this.collapseMenu(secondary, toggle);
    }
  }

  collapseMenu(menu, item) {
    menu.classList.add('hidden');

    item.classList.remove('down');
    item.classList.add('up');
  }

  expandMenu(menu, item) {
    this.collapseAllOpenMenus();
    menu.classList.remove('hidden');

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
}
