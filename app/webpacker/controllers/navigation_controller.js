import { Controller } from '@hotwired/stimulus';

const desktopSelectors = 'ol.category-navigation, ol.page-navigation';
const mobileSelectors = 'ol.category-links-list, ol.page-links-list';

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
    console.log('handleNavMenuClick');

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
        // TODO: contract all other expanded icons NOT IN ROOT

        this.showMenu(childMenu);
        this.showMenu(childMenuSync);
      } else if (this.toggleIconContracted(item)) {
        this.toggleIconContracted(itemSync);
        this.hideMenu(childMenu);
        this.hideMenu(childMenuSync);
      }
    }
  }

  getTargetItem(id) {
    console.log('getTargetItem id:', id);
    if (id) {
      if (id.endsWith('-desktop')) {
        console.log('this.desktopTarget', this.desktopTarget);
        return this.desktopTarget.querySelector('#' + id);
      } else if (id.endsWith('-mobile')) {
        return this.navTarget.querySelector('#' + id);
      }
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



//
//
//   [].forEach.call(
//     this.navTarget.querySelectorAll(selectors),
//     function (child) {
//       if (
//         toggleIds.includes(child.id) &&
//         child.classList.contains('hidden-menu')
//       ) {
//         child.classList.remove('hidden-menu');
//       } else if (
//         !toggleIds.includes(child.id) &&
//         !child.classList.contains('hidden-menu')
//       ) {
//         child.classList.add('hidden-menu');
//       }
//     }
//   );
// }


// const ol = event.target.closest('ol');
// const selectedIcon = li.querySelector('span.nav-icon');

// const iconList = this.navTarget.querySelectorAll('span.nav-icon') +
//   this.desktopTarget.querySelectorAll('span.nav-icon');
//
//
// const toggleIds = li.dataset.toggleIds || [];
// const selectors = ol.dataset.selectors || menuSelectors;
//
// console.log('handleNavMenuClick.selectors', selectors);
// console.log('handleNavMenuClick.toggleIds', toggleIds);
//
// this.toggleMenuItem(iconList);


// handleDesktopMenuClick(event) {
//   // fires when the user clicks on a desktop menu item
//   console.log('handleDesktopMenuClick');
//
//   const ol = event.target.closest('ol');
//   const li = event.target.closest('li');
//   const selectedIcon = li.querySelector('span.nav-icon');
//
//   const iconList = this.navTarget.querySelectorAll('span.nav-icon') +
//     this.desktopTarget.querySelectorAll('span.nav-icon');
//
//
//
//   // const selectors = ol.dataset.selectors || menuSelectors;
//   // const toggleIds = li.dataset.toggleIds || [];
//
//   console.log('toggleDesktopMenuItem.selectors', selectors);
//   console.log('toggleDesktopMenuItem.toggleIds', toggleIds);
// }




// toggleMenuItem(iconList, selected) {
//   [].forEach.call(
//     iconList,
//     //this.navTarget.querySelectorAll('span.nav-icon'),
//     function (icon) {
//       if (icon === selectedIcon) {
//         console.log('icon', icon);
//
//         if (self.toggleIconUp(icon)) {
//           if (!(li.dataset.directLink === 'true')) {
//             event.preventDefault();
//             event.stopPropagation();
//             self.showMenu(toggleIds.split(' '), selectors);
//             li.querySelector('a').ariaExpanded = true;
//           }
//         } else {
//           event.preventDefault();
//           event.stopPropagation();
//           self.toggleIconDown(icon);
//           self.hideMenu(selectors);
//           li.querySelector('a').ariaExpanded = false;
//         }
//       } else {
//         self.toggleIconDown(icon);
//         icon.closest('li').querySelector('a').ariaExpanded = false;
//       }
//     }
//   );
// }





// showMenu(toggleIds, selectors) {
//   [].forEach.call(
//     this.navTarget.querySelectorAll(selectors),
//     function (child) {
//       if (
//         toggleIds.includes(child.id) &&
//         child.classList.contains('hidden-menu')
//       ) {
//         child.classList.remove('hidden-menu');
//       } else if (
//         !toggleIds.includes(child.id) &&
//         !child.classList.contains('hidden-menu')
//       ) {
//         child.classList.add('hidden-menu');
//       }
//     }
//   );
// }
//
// hideMenu(selectors) {
//   [].forEach.call(
//     this.navTarget.querySelectorAll(selectors),
//     function (child) {
//       if (!child.classList.contains('hidden-menu')) {
//         child.classList.add('hidden-menu');
//       }
//     }
//   );
// }

