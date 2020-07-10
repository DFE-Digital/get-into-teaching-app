import { Controller } from "stimulus"

export default class extends Controller {

    static targets = ["overlay"]

    connect() {
        this.checkforCookie();
    }

    checkforCookie() {
        var cookie = document.cookie;
        var cookieFrags = cookie.split(';');
        for(var i=0;i<cookieFrags.length;i+=1) {
            if(cookieFrags[i].indexOf('GiTBetaCookie=Accepted') > -1) {
                return;
            }
        }
        this.showDialog();
    }

    accept(event) {
        event.preventDefault();
        this.overlayTarget.style.display = "none";
        document.cookie = "GiTBetaCookie=Accepted; expires=Fri, 31 Dec 2021 12:00:00 UTC";
    }

    showDialog() {
        this.overlayTarget.style.display = "flex";
    }

}