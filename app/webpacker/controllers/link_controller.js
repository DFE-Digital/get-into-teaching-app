import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['content'];

  connect() {
    this.prepareChevronOnButtonLinks();
    this.openExternalContentLinksInNewWindow();
  }

  openExternalContentLinksInNewWindow() {
    const links = this.contentTarget.querySelectorAll('a');

    links.forEach((l) => {
      if (l.getAttribute('href')?.startsWith('http')) {
        l.setAttribute('target', '_blank');
        l.setAttribute('rel', 'noopener');

        // add hidden text to inform screen reader users that
        // link will open in a new window
        const linkOpensInNewWindow = document.createElement('span');
        const text = document.createTextNode('(Link opens in new window)');
        linkOpensInNewWindow.classList.add('govuk-visually-hidden');
        linkOpensInNewWindow.appendChild(text);
        l.appendChild(linkOpensInNewWindow);
      }
    });
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
