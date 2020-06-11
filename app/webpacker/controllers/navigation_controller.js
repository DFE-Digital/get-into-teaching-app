import { Controller } from "stimulus"

export default class extends Controller {

    static targets = [ "hamburger", "label", "links" ]

    connect() {
        this.navToggle();
    }

    navToggle() {
        if (this.linksTarget.style.display === "block" || this.linksTarget.style.display === "") {
            this.linksTarget.style.display = "none";
            this.hamburgerTarget.className = 'icon-hamburger';
            this.labelTarget.innerHTML = "Menu";
        } else {
            this.linksTarget.style.display = "block";
            this.hamburgerTarget.className = 'icon-close';
            this.labelTarget.innerHTML = "Close";
        }
    }

}