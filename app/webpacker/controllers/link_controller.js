import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["content"];

    connect() {
        this.preventTurboLinksOnJumpLinks();
        this.openExternalContentLinksInNewWindow();
    }

    preventTurboLinksOnJumpLinks() {
        const links = this.contentTarget.querySelectorAll('a');

        links.forEach((l) => {
            if (l.getAttribute('href')?.includes('#')) {
                l.dataset.turbolinks = "false"
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
              const linkOpensInNewWindow = document.createElement("span");
              const text = document.createTextNode("(Link opens in new window)");
              linkOpensInNewWindow.classList.add('govuk-visually-hidden');
              linkOpensInNewWindow.appendChild(text)
              l.appendChild(linkOpensInNewWindow);
            }
        });
    }
}
