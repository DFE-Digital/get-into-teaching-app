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
    if (!item) return;

    const directLink = item.dataset.directLink === 'true';
    if (directLink) return;

    const itemSync = this.getTargetItem(item.dataset.syncId);
    const childMenu = this.getTargetItem(item.dataset.childMenuId);
    const childMenuSync = this.getTargetItem(item.dataset.childMenuSyncId);
    const toggleSecondaryNavigation = item.dataset.toggleSecondaryNavigation;

    event.preventDefault();
    event.stopPropagation();

    if (this.toggleIconExpanded(item)) {
      this.toggleIconExpanded(itemSync);
      this.showMenu(childMenu);
      this.showMenu(childMenuSync);
      this.contractAndHideSiblingMenus(item, itemSync);
      if (toggleSecondaryNavigation) {
        this.expandSecondaryNavigation();
      }
    } else if (this.toggleIconContracted(item)) {
      this.toggleIconContracted(itemSync);
      this.contractAndHideChildMenu(childMenu);
      this.contractAndHideChildMenu(childMenuSync);
      if (toggleSecondaryNavigation) {
        this.contractSecondaryNavigation();
      }
    }
  }

  handleMenuTab(event) {
    const item = event.target.closest('li');
    if (item && item.classList.contains('selected')) {
      const childMenu = this.getTargetItem(item.dataset.childMenuId);
      const nextItem = childMenu.querySelector('li > .menu-link');
      const childSyncMenu = this.getTargetItem(item.dataset.childMenuSyncId);
      const nextSyncItem = childSyncMenu.querySelector('li > .menu-link');

      if (nextItem) {
        nextItem.focus();
      }

      if (nextSyncItem) {
        nextSyncItem.focus();
      }

      event.preventDefault();
    }
  }

  getTarget(id) {
    if (!id) return;

    if (id.endsWith('-desktop')) {
      return this.desktopTarget;
    } else if (id.endsWith('-mobile')) {
      return this.navTarget;
    }
  }

  getTargetItem(id) {
    if (id) {
      return this.getTarget(id).querySelector('#' + id);
    }
  }

  toggleIcon(item, expanded = true) {
    if (!item) return false;
    const icon = item.querySelector('span.nav-icon');
    const linkOrButton = item.querySelector('a, button');

    if (!icon || !linkOrButton) return false;

    const currentClass = expanded ? 'nav-icon__contracted' : 'nav-icon__expanded';
    const newClass = expanded ? 'nav-icon__expanded' : 'nav-icon__contracted';

    if (icon.classList.contains(currentClass)) {
      icon.classList.replace(currentClass, newClass);
      item.classList.toggle('selected', expanded);
      linkOrButton.ariaExpanded = expanded;
      return true;
    }

    return false;
  }

  toggleIconExpanded(item) {
    return this.toggleIcon(item, true);
  }

  toggleIconContracted(item) {
    return this.toggleIcon(item, false);
  }

  toggleMenuVisibility(menu, show = true) {
    if (!menu) return false;

    const shouldHide = !show;
    const currentlyHidden = menu.classList.contains('hidden-menu');

    if (currentlyHidden === shouldHide) {
      menu.classList.toggle('hidden-menu', shouldHide);
      return true;
    }

    return false;
  }

  showMenu(menu) {
    return this.toggleMenuVisibility(menu, true);
  }

  hideMenu(menu) {
    return this.toggleMenuVisibility(menu, false);
  }

  expandSecondaryNavigation() {
    this.desktopTarget.classList.add('expanded');
  }

  contractSecondaryNavigation() {
    this.desktopTarget.classList.remove('expanded');
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
        if (childMenuItem) {
          // && childMenuItem.dataset && childMenuItem.dataset.childMenuId) {
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
