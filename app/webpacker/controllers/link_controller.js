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
            if (l.getAttribute('href')?.startsWith('#')) {
                l.dataset.turbolinks = "false"
            }
        });
    }

    openExternalContentLinksInNewWindow() {
        const links = this.contentTarget.querySelectorAll('.content a');

        links.forEach((l) => {
            if (l.getAttribute('href')?.startsWith('http')) {
              l.setAttribute('target', '_blank');
            }
        });
    }
}
