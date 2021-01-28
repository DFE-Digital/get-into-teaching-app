import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['hamburger', 'label', 'links'];

  connect() {
    this.navToggle();
  }

  navToggle() {
    const hide =
      this.linksTarget.style.display === 'block' ||
      this.linksTarget.style.display === '';
    this.linksTarget.style.display = hide ? 'none' : 'block';
    this.hamburgerTarget.className = hide ? 'icon-hamburger' : 'icon-close';
    this.labelTarget.innerHTML = hide ? 'Menu' : 'Close';
  }
}
