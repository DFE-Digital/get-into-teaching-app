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

    const correspondingItem = this.getTargetItem(item.dataset.correspondingId);
    const childMenu = this.getTargetItem(item.dataset.childMenuId);
    const correspondingChildMenu = this.getTargetItem(
      item.dataset.correspondingChildMenuId,
    );
    const toggleSecondaryNavigation = item.dataset.toggleSecondaryNavigation;

    const containerClassList = item.closest('ol').classList;
    let menuLevel;
    if (containerClassList.contains('primary')) {
      menuLevel = 1;
    } else if (containerClassList.contains('category-links-list')) {
      menuLevel = 2;
    } else if (containerClassList.contains('page-links-list')) {
      menuLevel = 3;
    }

    event.preventDefault();
    event.stopPropagation();

    if (this.toggleIconExpanded(item)) {
      this.toggleIconExpanded(correspondingItem);
      this.showMenu(childMenu);
      this.showMenu(correspondingChildMenu);
      this.contractAndHideSiblingMenus(item, correspondingItem);
      if (toggleSecondaryNavigation) {
        this.expandSecondaryNavigation();
      }
      window.gtag('event', 'expand_menu', {
        menuItemId: item.id,
        menuLevel: menuLevel,
      });
    } else if (this.toggleIconContracted(item)) {
      this.toggleIconContracted(correspondingItem);
      this.contractAndHideChildMenu(childMenu);
      this.contractAndHideChildMenu(correspondingChildMenu);
      if (toggleSecondaryNavigation) {
        this.contractSecondaryNavigation();
      }
      window.gtag('event', 'contract_menu', {
        menuItemId: item.id,
        menuLevel: menuLevel,
      });
    }
  }

  handleMenuTab(event) {
    const item = event.target.closest('li');
    if (!item) return false;

    const nextItem = this.getNext(item);
    if (!nextItem) {
      // When there is no next item set the focus to below the dropdown menu
      document.querySelector('.tab-after-nav-menu').focus();
      return false;
    }

    event.preventDefault();
    nextItem.querySelector('.menu-link').focus();

    const correspondingNextItem = this.getTargetItem(
      nextItem.dataset.correspondingId,
    );
    if (!correspondingNextItem) return false;
    correspondingNextItem.querySelector('.menu-link').focus();
  }

  getNext(item) {
    if (!item) return;

    if (item.classList.contains('selected') && item.dataset.childMenuId) {
      const nextChild = this.getTargetItem(
        item.dataset.childMenuId,
      ).querySelector('li');
      if (nextChild) return nextChild;
    }

    const nextSibling = item.nextElementSibling;
    if (nextSibling) return nextSibling;

    // If the current item is from the primary nav list and there is no sibling
    // return null and let the handler move the focus to below the nav menu
    const parentList = item.closest('ol');
    if (parentList.classList.contains('primary')) return;

    const nextCategoryItem = this.desktopTarget.querySelector(
      'div.category-links > ol > li.selected',
    )?.nextElementSibling;
    const nextPrimaryItem =
      this.primaryTarget.querySelector('li.selected')?.nextElementSibling;

    if (parentList.classList.contains('page-links-list'))
      return nextCategoryItem || nextPrimaryItem;

    if (parentList.classList.contains('category-links-list'))
      return nextPrimaryItem;
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

  toggleIcon(item, expand = true) {
    if (!item) return false;
    const icon = item.querySelector('span.nav-icon');
    const linkOrButton = item.querySelector('a, button');

    if (!icon || !linkOrButton) return false;

    const currentClass = expand ? 'nav-icon__contracted' : 'nav-icon__expanded';
    const newClass = expand ? 'nav-icon__expanded' : 'nav-icon__contracted';

    if (icon.classList.contains(currentClass)) {
      icon.classList.replace(currentClass, newClass);
      item.classList.toggle('selected', expand);
      linkOrButton.ariaExpanded = expand;
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

  toggleMenuVisibility(menu, shouldHide = true) {
    if (!menu) return false;

    const currentlyHidden = menu.classList.contains('hidden-menu');

    if (currentlyHidden === shouldHide) return false;

    menu.classList.toggle('hidden-menu', shouldHide);
    return true;
  }

  showMenu(menu) {
    return this.toggleMenuVisibility(menu, false);
  }

  hideMenu(menu) {
    return this.toggleMenuVisibility(menu, true);
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
          const correspondingItem = self.getTargetItem(
            sibling.dataset.correspondingId,
          );

          self.toggleIconContracted(correspondingItem);
          self.contractAndHideChildItem(sibling);
          self.contractAndHideChildItem(correspondingItem);
        }
      }
    });
  }

  contractAndHideChildItem(item) {
    if (!item) return;

    const childMenu = this.getTargetItem(item.dataset.childMenuId);
    const correspondingChildMenu = this.getTargetItem(
      item.dataset.correspondingChildMenuId,
    );
    this.contractAndHideChildMenu(childMenu);
    this.contractAndHideChildMenu(correspondingChildMenu);
  }

  contractAndHideChildMenu(menu) {
    if (!menu) return;

    const self = this;
    self.hideMenu(menu);

    [].forEach.call(menu.children, function (childMenuItem) {
      if (childMenuItem) {
        self.toggleIconContracted(childMenuItem);
        self.contractAndHideChildItem(childMenuItem);
      }
    });
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
