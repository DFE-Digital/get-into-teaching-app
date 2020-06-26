import { Controller } from "stimulus"

export default class extends Controller {

    static targets = [ "player", "iframe", "link"]

    connect() {
        this.activateJavascriptPlayer();
    }

    activateJavascriptPlayer() {
        for(var link of this.linkTargets) {
            link.removeAttribute('target');
        }
    }

    play(event) {
        event.preventDefault();
        var link = event.target.closest('a');
        this.iframeTarget.src = link.href.replace('https://www.youtube.com/watch?v=','https://www.youtube.com/embed/');
        this.playerTarget.style.display = "flex";
    }

    close() {
        this.playerTarget.style.display = "none";
    }

}