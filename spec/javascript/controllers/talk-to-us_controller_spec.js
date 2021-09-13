import { Application } from 'stimulus';
import TalkToUsController from 'talk-to-us_controller.js';

describe('TalkToUsController', () => {
  let button;

  const setBody = (zendeskEnabled) => {
    document.body.innerHTML = `
      <a
        href="#"
        data-controller="talk-to-us"
        data-action="click->talk-to-us#startChat"
        data-talk-to-us-zendesk-enabled-value="${zendeskEnabled}"
      >Chat Online</a>
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('talk-to-us', TalkToUsController);
    button = document.querySelector('a');
  }

  describe("when Zendesk Chat is disabled", () => {
    const openSpy = jest.fn();

    beforeEach(() => {
      jest.spyOn(global, 'window', 'get').mockImplementation(() => ({ open: openSpy }));

      setBody(false);
      registerController();
    });

    it('opens the klick2contact chat when clicking the button', () => {
      const button = document.querySelector('a');
      button.click();

      const url =
        'https://gov.klick2contact.com/v03/launcherV3.php?p=DfE&d=971&ch=CH&psk=chat_a2&iid=STC&srbp=0&fcl=0&r=Static&s=https://gov.klick2contact.com/v03&u=&wo=&uh=&pid=82&iif=0';
      const target = 'Get Into Teaching: Chat online';
      const features =
        'menubar=no,location=yes,resizable=yes,scrollbars=no,status=yes,width=340,height=480';

      expect(openSpy).toBeCalledWith(url, target, features);
    });
  });

  describe("when Zendesk Chat is enabled", () => {
    const chatShowSpy = jest.fn();

    beforeEach(() => {
      jest.spyOn(global, 'window', 'get').mockImplementation(() => ({ $zopim: { livechat: { window: { show: chatShowSpy } } } }));

      setBody(true);
      registerController();
    });

    it('opens the Zendesk Chat widget when clicking the button', () => {
      const button = document.querySelector('a');
      button.click();

      expect(chatShowSpy).toBeCalledWith();
    });
  });
});
