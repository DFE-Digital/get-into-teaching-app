import { Application } from 'stimulus';
import FeedbackController from 'feedback_controller';

describe('FeedbackController', () => {
  document.body.innerHTML = `
  <div id="feedback" data-controller="feedback">
    <p id="text" data-feedback-target="text">Is this page helpful?</p>
    <a href="javascript:void(0)" id="answerButton" data-feedback-target="link" data-action="feedback#answer">Answer</a>
  </div>
  `;

  const application = Application.start();
  application.register('feedback', FeedbackController);
  const answerButton = document.getElementById('answerButton');

  describe('on connect', () => {
    it('displays the page helpful HTML', () => {
      const feedback = document.getElementById('feedback');
      expect(feedback.classList).toContain('visible');
    });
  });

  describe('submitting an answer', () => {
    it('hides the links', () => {
      answerButton.click();
      expect(answerButton.classList).toContain('hidden');
    });

    it('displays a thank you message', () => {
      answerButton.click();
      const text = document.getElementById('text');
      expect(text.textContent).toEqual('Thank you for your feedback');
    });
  });
});
