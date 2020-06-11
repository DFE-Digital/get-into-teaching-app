import { Controller } from "stimulus"

export default class extends Controller {

    connect() {
        this.navToggle();
    }

    navToggle() {
        var links = document.getElementById("navbar-mobile-links");
        var icon = document.getElementById("hamburger");
        var label = document.getElementById("navbar-label");
        if (links.style.display === "block" || links.style.display === "") {
            links.style.display = "none";
            icon.className = 'icon-hamburger';
            label.innerHTML = "Menu";
        } else {
            links.style.display = "block";
            icon.className = 'icon-close';
            label.innerHTML = "Close";
        }
    }

}