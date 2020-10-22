import { Application } from 'stimulus' ;
import FeedbackController from 'feedback_controller.js';

class fakeLocalStorage {
  constructor(store = {}) {
    this.store = store;
  }

  getItem(key) {
    return this.store[key]
  }

  setItem(key, value) {
    return this.store[key] = value
  }
}

describe('FeedbackController', () => {
  beforeEach(() => {
    document.body.innerHTML = `
      <div id="feedback-bar" class="feedback-bar" data-controller="feedback" data-banner-name="Feedback">
        <div class="container-1000">
            <div class="feedback-bar__inner">
                <div class="feedback-bar__left">
                    <span class="feedback-bar__label">FEEDBACK</span>
                    <span class="feedback-bar__description">Give us <a href="/some/page" target="blank" data-action="click->feedback#giveFeedback">feedback on this website</a>.</span>
                </div>
                <a href="" class="feedback-bar__close" id="hide-feedback-bar" data-action="click->feedback#dismiss">Hide</a>
            </div>
        </div>
      </div>
    `;
  })

  describe("clicking hide", () => {
    beforeEach(() => {
      const application = Application.start();
      application.register('feedback', FeedbackController);
    })

    it('hides the feedback bar', () => {
      const feedbackBar = document.getElementById('feedback-bar');
      const hideLink = document.getElementById('hide-feedback-bar');
      hideLink.click();
      expect(feedbackBar.style.display).toContain('none');
    })
  })

  describe("clicking 'Give us feedback on this website'", () => {
    beforeEach(() => {
      const application = Application.start();
      application.register('feedback', FeedbackController);
    })

    it('hides the feedback bar', () => {
      const feedbackBar = document.getElementById('feedback-bar');
      const hideLink = document.getElementById('hide-feedback-bar');
      hideLink.click();
      expect(feedbackBar.style.display).toContain('none');
    })
  })

  describe("when the user has visited fewer than 3 pages", () => {
    beforeEach(() => {
      window.localStorage.setItem('feedbackPageCount', '1')

      const application = Application.start();
      application.register('feedback', FeedbackController);
    })

    it('the feedback bar is never shown', () => {
      const feedbackBar = document.getElementById('feedback-bar');
      expect(feedbackBar.style.display).toEqual('')
    })
  })

  describe("when the user has visited 3 or more pages", () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', { value: new fakeLocalStorage() });
      window.localStorage.setItem('feedbackPageCount', '5')

      const application = Application.start();
      application.register('feedback', FeedbackController);
    })

    it('shows the feedback bar', () => {
      const feedbackBar = document.getElementById('feedback-bar');
      expect(feedbackBar.style.display).toContain('flex');
    })
  })

  describe("viewing a page increments the counter", () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', { value: new fakeLocalStorage() });
      window.localStorage.setItem('feedbackPageCount', '2')

      const application = Application.start();
      application.register('feedback', FeedbackController);
    })

    it("the counter has increased by one", () => {
      const newCount = window.localStorage.getItem('feedbackPageCount')
      // the real localStorage would cast this to a String
      expect(newCount).toEqual(3)
    })
  })

  describe("dismissing the feedback box", () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', { value: new fakeLocalStorage({'feedbackPageCount': '2'}) });

      const application = Application.start();
      application.register('feedback', FeedbackController);
    })

    it("the dismissed flag should be true", () => {
      const hideLink = document.getElementById('hide-feedback-bar');
      hideLink.click();

      const flag = window.localStorage.getItem('feedbackDismissed')
      expect(flag).toEqual("true")
    })
  })

  describe("once dismissed the feedback bar shouldn't be shown", () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', { value: new fakeLocalStorage({ feedbackDismissed: "true", feedbackPageCount: "8" }) });

      const application = Application.start();
      application.register('feedback', FeedbackController);
    })

    it("the feedback bar shouldn't be shown", () => {
      const feedbackBar = document.getElementById('feedback-bar');

      expect(feedbackBar.style.display).toEqual('')
    })
  })
})
