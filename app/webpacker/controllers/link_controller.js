import { Controller } from "stimulus"

export default class extends Controller {

    static targets = [ "content"];

    connect() {
        this.preventTurboLinksOnJumpLinks();
    }

    preventTurboLinksOnJumpLinks() {
        const links = this.contentTarget.querySelectorAll('a');
        links.forEach((l) => {
            if (l.getAttribute('href')?.startsWith('#')) {
                l.dataset.turbolinks = "false"
            }
        });
    }
        
}
