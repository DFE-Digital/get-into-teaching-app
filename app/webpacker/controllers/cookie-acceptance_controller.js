import { Controller } from "stimulus"

export default class extends Controller {

    static targets = ["modal","overlay","agree","disagree"];

    connect() {
        this.checkforCookie();
    }

    checkforCookie() {
        var cookie = document.cookie;
        if(cookie.indexOf('GiTBetaCookie=Accepted') > -1) {
            return;
        }
        this.showDialog();
    }

    accept(event) {
        event.preventDefault();
        this.overlayTarget.style.display = "none";
        document.cookie = "GiTBetaCookie=Accepted; expires=Fri, 31 Dec 2021 12:00:00 UTC";

        let acceptedCookies = new Event("cookies:accepted") ;
        document.dispatchEvent(acceptedCookies) ;
    }

    showDialog() {
        this.overlayTarget.style.display = "flex";
        document.getElementById('cookies-agree').focus();

        this.disagreeTarget.addEventListener('blur', function (e) {
            e.preventDefault();
            document.getElementById('cookies-agree').focus();
        });

        this.agreeTarget.addEventListener('blur', function (e) {
            e.preventDefault();
            document.getElementById('cookies-disagree').focus();
        });
    }

}
