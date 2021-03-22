import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['hamburger', 'label', 'links'];
  static closedClass = 'navbar__mobile--closed';

  connect() {
    this.navToggle()

    this.searchHandler = this.hide.bind(this)
    document.addEventListener('navigation:search', this.searchHandler)
  }

  disconnect() {
    if (document && this.searchHandler)
      document.removeEventListener('navigation:menu', this.searchHandler)
  }

  navToggle() {
    this.visible ? this.hide() : this.show()
  }

  show() {
    this.element.classList.remove(this.constructor.closedClass) ;

    this.linksTarget.style.display = 'block';
    this.hamburgerTarget.className = 'icon-close';
    this.labelTarget.innerHTML = 'Close';

    this.notify()
  }

  hide() {
    this.element.classList.add(this.constructor.closedClass) ;

    this.linksTarget.style.display = 'none';
    this.hamburgerTarget.className = 'icon-hamburger';
    this.labelTarget.innerHTML = 'Menu';
  }

  get visible() {
    return !this.element.classList.contains(this.constructor.closedClass)
  }

  notify() {
    const showingMenuEvent = new CustomEvent('navigation:menu');

    document.dispatchEvent(showingMenuEvent);
  }
}
