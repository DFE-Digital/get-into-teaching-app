import { Application } from '@hotwired/stimulus';
import ChatController from 'chat_controller.js';

describe('ChatController', () => {
  beforeAll(() => registerController());
  afterEach(() => jest.useRealTimers());

  const setBody = (chatAvailable = 'true') => {
    document.body.innerHTML = `
      <div data-controller="chat" data-available="${chatAvailable}" data-chat-target="container" class="chat">
        <div data-chat-target="online" class="hidden">
          <p>
            <a class="button" href="javascript:void(0)" data-action="chat#start" data-chat-target="chat">Chat online</a>
          </p>
        </div>
        <div data-chat-target="offline" class="hidden">
          <p>
            Chat is <strong>closed</strong>
          </p>
        </div>
        <div data-chat-target="unavailable">
          <p>
            <strong>Chat not available</strong>
            <br>
            Email: <a class="link--dark" href="mailto:getinto.teaching@service.education.gov.uk">getinto.teaching@service.education.gov.uk</a>
          </p>
        </div>
      </div>
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('chat', ChatController);
  }

  const mockFetch = (result) => {
    global.fetch = jest.fn(() => {
      return Promise.resolve({
        json: () => (result)
      })
    })
  }

  describe('chat', () => {

    describe('when the chat is online', () => {
      beforeEach(() => {
        mockFetch({ "skillid": 123456, "available": true, "status_age": 123 } );
        setBody('true');
      });

      it('hides the unavailable message', () => {
        const button = document.querySelector('[data-chat-target="unavailable"]')
        expect(button.classList.contains('hidden')).toBe(true)
      })

      it('displays the chat online button', () => {
        const button = document.querySelector('[data-chat-target="online"]')
        expect(button.classList.contains('hidden')).toBe(false)
      })
    });

    describe('when the chat is offline', () => {
      beforeEach(() => {
        mockFetch({ "skillid": 123456, "available": false, "status_age": 123 } );
        setBody('false');
      });

      it('hides the unavailable message', () => {
        const button = document.querySelector('[data-chat-target="unavailable"]')
        expect(button.classList.contains('hidden')).toBe(true)
      })

      it('displays the chat offline message', () => {
        const button = document.querySelector('[data-chat-target="offline"]')
        expect(button.classList.contains('hidden')).toBe(false)
      })
    });
  });
});
