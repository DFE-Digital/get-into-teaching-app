import { Controller } from "stimulus"

export default class extends Controller {

    static targets = [ "player", "iframe", "link", "close"]

    connect() {
        this.activateJavascriptPlayer();
    }
    

    activateJavascriptPlayer() {
        for(var link of this.linkTargets) {
            link.removeAttribute('target');
        }
        var myFrame = this.iframeTarget;
        
        this.closeTarget.addEventListener('blur', function (e) {
            e.preventDefault();
            myFrame.contentWindow.focus();
        });
    }

    play(event) {
        event.preventDefault();
        var link = event.target.closest('a');
        this.iframeTarget.src = link.href.replace('https://www.youtube.com/watch?v=','https://www.youtube.com/embed/');
        this.playerTarget.style.display = "flex";
        this.iframeTarget.contentWindow.focus();
    }

    close() {
        this.linkTarget.focus();
        this.playerTarget.style.display = "none";
    }



}