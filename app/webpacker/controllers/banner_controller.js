import { Controller } from "stimulus"

export default class extends Controller {
    hide(e) {
        e.preventDefault();
        this.element.style.display = "none";
    }
}