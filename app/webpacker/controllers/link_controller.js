import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['content'];
  static values = {
    assetsUrl: String,
  };

  connect() {
    this.prepareChevronOnButtonLinks();
    this.openExternalContentLinksInNewWindow();
    this.preventTurboLinksOnJumpLinks();
  }

  openExternalContentLinksInNewWindow() {
    const links = Array.from(this.contentTarget.querySelectorAll('a'));

    links
      .filter((l) => this.isExternal(l))
      .forEach((l) => {
        l.setAttribute('target', '_blank');
        l.setAttribute('rel', 'noopener');
      });
  }

  preventTurboLinksOnJumpLinks() {
    const links = this.contentTarget.querySelectorAll('a');

    links.forEach((l) => {
      if (l.getAttribute('href')?.includes('#')) {
        l.dataset.turbolinks = 'false';
      }
    });
  }

  isExternal(link) {
    const href = link.getAttribute('href');

    return (
      href?.startsWith('http') &&
      !href?.includes(this.assetsUrlValue || window.location.host)
    );
  }

  prepareChevronOnButtonLinks() {
    const links = this.contentTarget.querySelectorAll(
      '.button,.type-description__link'
    );

    [...links]
      .filter((link) => link.querySelector('span') === null) // don't touch buttons that already include a span
      .forEach((link) => {
        link.innerHTML = this.wrapFinalWordInSpan(
          link.textContent.trim().split(' ')
        );
      });
  }

  wrapFinalWordInSpan(words) {
    return words.concat(`<span>${words.pop()}</span>`).join(' ');
  }
}
