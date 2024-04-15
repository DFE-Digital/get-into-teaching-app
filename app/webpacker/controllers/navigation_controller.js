import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['primary', 'menu', 'nav', 'desktop'];

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

  handleNavMenuClick(event) {
    // fires when the user clicks on a navigation menu item
    const item = event.target.closest('li');
    const directLink = item.dataset.directLink === 'true';
    const itemSync = this.getTargetItem(item.dataset.syncId);
    const childMenu = this.getTargetItem(item.dataset.childMenuId);
    const childMenuSync = this.getTargetItem(item.dataset.childMenuSyncId);

    if (item && !directLink) {
      event.preventDefault();
      event.stopPropagation();

      if (this.toggleIconExpanded(item)) {
        this.toggleIconExpanded(itemSync);
        this.showMenu(childMenu);
        this.showMenu(childMenuSync);
        this.contractAndHideSiblingMenus(item, itemSync);
      } else if (this.toggleIconContracted(item)) {
        this.toggleIconContracted(itemSync);
        this.hideMenu(childMenu);
        this.hideMenu(childMenuSync);
      }
    }
  }

  getTarget(id) {
    if (id) {
      if (id.endsWith('-desktop')) {
        return this.desktopTarget;
      } else if (id.endsWith('-mobile')) {
        return this.navTarget;
      }
    }
  }

  getTargetItem(id) {
    if (id) {
      return this.getTarget(id).querySelector('#' + id);
    }
  }

  toggleIconExpanded(item) {
    if (item) {
      const icon = item.querySelector('span.nav-icon');
      if (icon) {
        if (icon.classList.contains('nav-icon__arrow-down')) {
          icon.classList.remove('nav-icon__arrow-down');
          icon.classList.add('nav-icon__arrow-up');
          item.querySelector('a,btn').ariaExpanded = true;
          return true;
        }
        return false;
      }
    }
  }

  toggleIconContracted(item) {
    if (item) {
      const icon = item.querySelector('span.nav-icon');
      if (icon) {
        if (icon.classList.contains('nav-icon__arrow-up')) {
          icon.classList.remove('nav-icon__arrow-up');
          icon.classList.add('nav-icon__arrow-down');
          item.querySelector('a,btn').ariaExpanded = false;
          return true;
        }
        return false;
      }
    }
  }

  showMenu(menu) {
    if (menu) {
      if (menu.classList.contains('hidden-menu')) {
        menu.classList.remove('hidden-menu');
        return true;
      } else {
        return false;
      }
    }
  }

  hideMenu(menu) {
    if (menu) {
      if (!menu.classList.contains('hidden-menu')) {
        menu.classList.add('hidden-menu');
        return true;
      } else {
        return false;
      }
    }
  }

  contractAndHideSiblingMenus(item) {
    const self = this;
    [].forEach.call(item.closest('ol').children, function (sibling) {
      if (sibling !== item) {
        if (self.toggleIconContracted(sibling)) {
          const syncItem = self.getTargetItem(sibling.dataset.syncId);

          self.toggleIconContracted(syncItem);
          self.contractAndHideChildItem(sibling);
          self.contractAndHideChildItem(syncItem);
        }
      }
    });
  }

  contractAndHideChildItem(item) {
    if (item) {
      const childMenu = this.getTargetItem(item.dataset.childMenuId);
      const childSyncMenu = this.getTargetItem(item.dataset.childMenuSyncId);

      this.contractAndHideChildMenu(childMenu);
      this.contractAndHideChildMenu(childSyncMenu);
    }
  }

  contractAndHideChildMenu(menu) {
    if (menu) {
      const self = this;
      self.hideMenu(menu);

      [].forEach.call(menu.children, function (childMenuItem) {
        if (childMenuItem) { // && childMenuItem.dataset && childMenuItem.dataset.childMenuId) {
          self.toggleIconContracted(childMenuItem);
          self.contractAndHideChildItem(childMenuItem);
        }
      });
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

  get menuToggler() {
    return document.getElementById('menu-toggle');
  }
}
