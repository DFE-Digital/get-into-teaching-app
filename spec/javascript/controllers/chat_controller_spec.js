import { Application } from '@hotwired/stimulus';
import ChatController from 'chat_controller.js';

describe('ChatController', () => {

  beforeAll(() => registerController());
  afterEach(() => jest.useRealTimers());

  let chatShowSpy;
  let chatOpenSpy;

  const setBody = () => {
    document.body.innerHTML = `
      <div data-controller="chat">
        <div data-chat-target="online" class="hidden">
          <a href="javascript:void(0)" data-action="chat#start" data-chat-target="chat">Chat online</a>
        </div>
        <div data-chat-target="offline" class="hidden">
          Chat closed
        </div>
        <div data-chat-target="unavailable">
          Chat unavailable
        </div>
      </div>
      <iframe id="webWidget"></iframe> // Zendesk modal.
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('chat', ChatController);
  }

  const setCurrentTime = (time) => {
    jest.useFakeTimers().setSystemTime(new Date(time).getTime())
  }

  const getButtonText = () => {
    return document.querySelector('a').textContent;
  }

  describe('when the chat is online', () => {
    beforeEach(() => {
      chatShowSpy = jest.fn(() => true);
      chatOpenSpy = jest.fn();

      jest.spyOn(global, 'window', 'get').mockImplementation(() => ({ zE: chatOpenSpy, zEACLoaded: chatShowSpy }));

      setBody();
      setCurrentTime('2021-01-01 10:00');
    });

    it('hides the unavailable message', () => {
      const button = document.querySelector('[data-chat-target="unavailable"]')
      expect(button.classList.contains('hidden')).toBe(true)
    })

    it('displays the chat online button', () => {
      const button = document.querySelector('[data-chat-target="online"]')
      expect(button.classList.contains('hidden')).toBe(false)
    })

    describe('when clicking the chat button', () => {
      it('appends the Zendesk snippet, shows a loading message and then opens the chat window', () => {
        const button = document.querySelector('a');
        button.click();
        expect(document.querySelector('#ze-snippet')).not.toBeNull();
        expect(getButtonText()).toEqual("Starting chat...");
        jest.runOnlyPendingTimers(); // Timer for script loading,
        jest.runOnlyPendingTimers(); // Timer to wait for the widget to load.
        jest.runOnlyPendingTimers(); // Timer to wait for chat window to open.
        expect(chatOpenSpy).toHaveBeenCalled();
        expect(getButtonText()).toEqual("Chat online");
      });
    });

    describe('when clicking the chat button twice', () => {
      it('only appends the Zendesk snippet once and does not show the loading message for the second click', () => {
        const button = document.querySelector('a');
        button.click();
        expect(button.textContent).toEqual("Starting chat...");
        jest.runOnlyPendingTimers(); // Timer for script loading,
        jest.runOnlyPendingTimers(); // Timer to wait for the widget to load.
        jest.runOnlyPendingTimers(); // Timer to wait for chat window to open.
        expect(chatOpenSpy).toHaveBeenCalled();
        expect(button.textContent).toEqual("Chat online");
        button.click();
        expect(button.textContent).toEqual("Chat online");
        expect(document.querySelectorAll('#ze-snippet').length).toEqual(1);
      });
    });
  })

  describe("when the chat is offline (too early)", () => {
    beforeEach(() => {
      setBody();
      setCurrentTime('2021-01-01 08:29');
    });

    it('displays the chat offline message', () => {
      const button = document.querySelector('[data-chat-target="offline"]')
      expect(button.classList.contains('hidden')).toBe(false)
    })
  })

  describe("when the chat is offline (too late)", () => {
    beforeEach(() => {
      setBody();
      setCurrentTime('2021-01-01 17:31');
    });

    it('displays the chat offline message', () => {
      const button = document.querySelector('[data-chat-target="offline"]')
      expect(button.classList.contains('hidden')).toBe(false)
    })
  })

  describe("when the chat is offline (weekend)", () => {
    beforeEach(() => {
      setBody();
      setCurrentTime('2021-12-18 11:00');
    });

    it('displays the chat offline message', () => {
      const button = document.querySelector('[data-chat-target="offline"]')
      expect(button.classList.contains('hidden')).toBe(false)
    })
  })
});
