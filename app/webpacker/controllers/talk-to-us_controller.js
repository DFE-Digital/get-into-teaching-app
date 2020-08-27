import { Controller } from "stimulus"

export default class extends Controller {

    static targets = ["chat", "launch", "tta"];

    connect() {
        this.showChatControls();
    }

    showChatControls() {
        this.chatTarget.style.display = 'inline-block';
        this.ttaTarget.style.width = "48%";
    }

    startChat(e) {
        e.preventDefault();
        var windowFeatures = "menubar=no,location=yes,resizable=yes,scrollbars=no,status=yes,width=340,height=480";
        window.open("https://gov.klick2contact.com/v03/launcherV3.php?p=DfE&d=971&ch=CH&psk=chat_a1&iid=STC&srbp=0&fcl=0&r=Static&s=https://gov.klick2contact.com/v03&u=&wo=&uh=&pid=82&iif=0",
        "Get into teaching: Chat online",
        windowFeatures);
    }

}