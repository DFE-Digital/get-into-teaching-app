import { Controller } from 'stimulus';

export default class extends Controller {
  static values = { zendeskEnabled: Boolean }

  connect() {
    this.show();
  }

  show() {
    this.element.classList.add('visible');
  }

  startChat(e) {
    e.preventDefault();

    if (this.zendeskEnabledValue) {
      this.showZendeskChat();
    } else {
      this.openKlick2ContactWindow();
    }
  }

  showZendeskChat() {
    window.$zopim.livechat.window.show();
  }

  openKlick2ContactWindow() {
    const windowFeatures =
      'menubar=no,location=yes,resizable=yes,scrollbars=no,status=yes,width=340,height=480';
    window.open(
      'https://gov.klick2contact.com/v03/launcherV3.php?p=DfE&d=971&ch=CH&psk=chat_a2&iid=STC&srbp=0&fcl=0&r=Static&s=https://gov.klick2contact.com/v03&u=&wo=&uh=&pid=82&iif=0',
      'Get Into Teaching: Chat online',
      windowFeatures
    );
  }
}
