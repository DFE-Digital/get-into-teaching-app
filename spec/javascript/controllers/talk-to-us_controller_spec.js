import { Application } from 'stimulus';
import TalkToUsController from 'talk-to-us_controller.js';

describe('TalkToUsController', () => {

  beforeAll(() => registerController());
  afterEach(() => jest.useRealTimers());

  let chatShowSpy;

  const setBody = (offlineText = null) => {
    document.body.innerHTML = `
      <div>
        <span data-controller="talk-to-us">
          <a
            href="#"
            data-action="click->talk-to-us#startChat"
            data-talk-to-us-target="button"
          ><span>Chat Online</span></a>
          ${offlineText ? `<p data-talk-to-us-target="offlineText">${offlineText}</p>` : ''}
        </span>
        <div> // Represents the Zendesk modal
          <iframe id="webWidget"></iframe>
        </div>
      </div>
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('talk-to-us', TalkToUsController);
  }

  const setCurrentTime = (time) => {
    jest.useFakeTimers().setSystemTime(new Date(time).getTime())
  }

  const getButtonText = () => {
    return document.querySelector('a span').textContent;
  }

  beforeEach(() => {
    chatShowSpy = jest.fn();
    jest.spyOn(global, 'window', 'get').mockImplementation(() => ({ $zopim: { livechat: { window: { show: chatShowSpy } } } }));

    setBody();
    setCurrentTime('2021-01-01 10:00');
  });

  it('appends the Zendesk snippet, opens the chat window and shows a loading message when clicking the button', () => {
    const button = document.querySelector('a');
    expect(document.activeElement.id).not.toEqual("webWidget");
    button.click();
    expect(document.querySelector('#ze-snippet')).not.toBeNull();
    expect(getButtonText()).toEqual("Starting chat...");
    jest.runOnlyPendingTimers(); // Timer for script loading,
    jest.runOnlyPendingTimers(); // Timer to wait for the widget to load.
    jest.runOnlyPendingTimers(); // Timer to wait for chat window to open.
    expect(chatShowSpy).toHaveBeenCalled();
    expect(getButtonText()).toEqual("Chat Online");
    expect(document.activeElement.id).toEqual("webWidget");
  });

  describe('when clicking the chat button twice', () => {
    it('only appends the Zendesk snippet once and does not show the loading message for the second click', () => {
      const button = document.querySelector('a');
      button.click();
      expect(button.textContent).toEqual("Starting chat...");
      jest.runOnlyPendingTimers(); // Timer for script loading,
      jest.runOnlyPendingTimers(); // Timer to wait for the widget to load.
      jest.runOnlyPendingTimers(); // Timer to wait for chat window to open.
      expect(chatShowSpy).toHaveBeenCalled();
      expect(button.textContent).toEqual("Chat Online");
      button.click();
      expect(button.textContent).toEqual("Chat Online");
      expect(document.querySelectorAll('#ze-snippet').length).toEqual(1);
    });
  });

  describe("when the chat is offline (too early) and there is no offline text", () => {
    beforeEach(() => {
      registerController();
      setBody();
      setCurrentTime('2021-01-01 08:29');
    });

    it('hides the chat button', () => {
      const button = document.querySelector('a');

      expect(button.classList.contains('hidden')).toBe(true)
    });
  })

  describe("when the chat is offline (too late) and there is offline text", () => {
    beforeEach(() => {
      registerController();
      setBody("Chat offline.");
      setCurrentTime('2021-01-01 17:31');
    });

    it('shows the offline text', () => {
      const offlineText = document.querySelector('p');

      expect(offlineText.classList.contains('visible')).toBe(true)
    })
  })
});
