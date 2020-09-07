import { Controller } from "stimulus"

export default class extends Controller {

    static targets = [ "banner", "hide"]

    connect() {
    }

    hidePhaseBanner(e) {
        e.preventDefault();
        this.bannerTarget.style.display = "none";
    }

}