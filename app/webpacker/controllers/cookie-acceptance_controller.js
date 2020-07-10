import { Controller } from "stimulus"

export default class extends Controller {

    static targets = ["overlay"]

    connect() {
        this.checkforCookie();
    }

    checkforCookie() {
        this.showDialog();
    }

    accept(event) {
        event.preventDefault();
        this.overlayTarget.style.display = "none";
    }

    showDialog() {
        this.overlayTarget.style.display = "flex";
    }

}