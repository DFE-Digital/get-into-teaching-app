import CookiePreferences from "../javascript/cookie_preferences" ;
import { Controller } from "stimulus"

export default class extends Controller {

    static targets = [ "player", "iframe", "link", "close"]

    connect() {
      if (this.playerAllowedByCookies) {
        this.activateJavascriptPlayer()
      } else {
        this.cookiesAcceptedHandler = this.cookiesAcceptedChecker.bind(this) ;
        document.addEventListener("cookies:accepted", this.cookiesAcceptedHandler) ;
      }
    }

    get playerAllowedByCookies() {
      const cookiePrefs = new CookiePreferences() ;
      return cookiePrefs.allowed('non-functional')
    }
    
    cookiesAcceptedChecker(event) {
      if (event.detail?.cookies?.includes('non-functional'))
        this.activateJavascriptPlayer();
    }

    enableVideoPlayer() {
      this.playerTarget.classList.add('playback-enabled') ;
    }

    get isVideoPlayerEnabled() {
      return this.playerTarget.classList.contains('playback-enabled') ;
    }

    activateJavascriptPlayer() {
        this.enableVideoPlayer() ;

        for(var link of this.linkTargets) {
            link.removeAttribute('target');
        }
        
        this.closeTarget.addEventListener('blur', (e) => {
            e.preventDefault();
            this.focusIframeWindow();
        });
    }

    play(event) {
        if (!this.isVideoPlayerEnabled)
          return ;

        event.preventDefault();
        var link = event.target.closest('a');
        this.iframeTarget.src = link.href.replace('https://www.youtube.com/watch?v=','https://www.youtube.com/embed/');
        this.playerTarget.style.display = "flex";
        this.focusIframeWindow();
    }

    close() {
        this.linkTarget.focus();
        this.playerTarget.style.display = "none";
        this.iframeTarget.src = this.iframeTarget.src;
    }

    focusIframeWindow() {
      this.iFrameTarget.contentWindow.focus();
    }
}
