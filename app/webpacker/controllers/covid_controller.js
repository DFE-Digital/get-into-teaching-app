import { Controller } from "stimulus"

export default class extends Controller {

    static targets = [ "banner", "hide"]

    connect() {
    }

    hideCovidBanner(e) {
        e.preventDefault();
        this.bannerTarget.style.display = "none";
    }

}