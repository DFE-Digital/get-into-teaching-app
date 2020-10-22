import { Application } from 'stimulus' ;
import FeedbackController from 'feedback_controller.js';

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

    const application = Application.start();
    application.register('feedback', FeedbackController);
  })

  describe("clicking hide", () => {
    it('hides the feedback bar', () => {
      const feedbackBar = document.getElementById('feedback-bar');
      const hideLink = document.getElementById('hide-feedback-bar');
      hideLink.click();
      expect(feedbackBar.style.display).toContain('none');
    })
  })

  describe("clicking 'Give us feedback on this website'", () => {
    it('hides the feedback bar', () => {
      const feedbackBar = document.getElementById('feedback-bar');
      const hideLink = document.getElementById('hide-feedback-bar');
      hideLink.click();
      expect(feedbackBar.style.display).toContain('none');
    })
  })
})
