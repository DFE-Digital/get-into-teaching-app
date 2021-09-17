import MockDate from 'mockdate'
import { Application } from 'stimulus';
import TalkToUsController from 'talk-to-us_controller.js';

describe('TalkToUsController', () => {
  let button;

  const setBody = (zendeskEnabled, offlineText = null) => {
    document.body.innerHTML = `
      <span data-controller="talk-to-us" data-talk-to-us-zendesk-enabled-value="${zendeskEnabled}">
        <a
          href="#"
          data-action="click->talk-to-us#startChat"
          data-talk-to-us-target="button"
        >Chat Online</a>
        ${offlineText ? `<p data-talk-to-us-target="offlineText">${offlineText}</p>` : ''}
      </span>
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('talk-to-us', TalkToUsController);
    button = document.querySelector('a');
  }

  const setCurrentTime = (time) => {
    MockDate.set(time);
  }

  describe("when Zendesk Chat is disabled", () => {
    const openSpy = jest.fn();

    beforeEach(() => {
      jest.spyOn(global, 'window', 'get').mockImplementation(() => ({ open: openSpy }));

      setCurrentTime('2021-01-01 10:00');
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
      setCurrentTime('2021-01-01 10:00');
      registerController();
    });

    it('opens the Zendesk Chat widget when clicking the button', () => {
      const button = document.querySelector('a');
      button.click();

      expect(chatShowSpy).toBeCalledWith();
    });
  });

  describe("when the chat is offline (too early) and there is no offline text", () => {
    beforeEach(() => {
      setBody(true);
      setCurrentTime('2021-01-01 08:29');
      registerController();
    });

    it('hides the chat button', () => {
      const button = document.querySelector('a');

      expect(button.classList.contains('hidden')).toBe(true)
    });
  })

  describe("when the chat is offline (too late) and there is offline text", () => {
    beforeEach(() => {
      setBody(true, "Chat offline.");
      setCurrentTime('2021-01-01 17:31');
      registerController();
    });

    it('shows the offline text', () => {
      const offlineText = document.querySelector('p');

      expect(offlineText.classList.contains('visible')).toBe(true)
    })
  })
});
