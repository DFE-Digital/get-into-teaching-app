import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['content'];

  connect() {
    this.preventTurboLinksOnJumpLinks();
    this.openExternalContentLinksInNewWindow();
    this.prepareChevronOnButtonLinks();
  }

  preventTurboLinksOnJumpLinks() {
    const links = this.contentTarget.querySelectorAll('a');

    links.forEach((l) => {
      if (l.getAttribute('href')?.includes('#')) {
        l.dataset.turbolinks = 'false';
      }
    });
  }

  openExternalContentLinksInNewWindow() {
    const links = this.contentTarget.querySelectorAll('.content a');

    links.forEach((l) => {
      if (l.getAttribute('href')?.startsWith('http')) {
        l.setAttribute('target', '_blank');

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
    const wordCount = words.length - 1;

    return words
      .map((word, i) => {
        console.debug(word, i);
        return i === wordCount ? `<span>${word}</span>` : word;
      })
      .join(' ');
  }
}
