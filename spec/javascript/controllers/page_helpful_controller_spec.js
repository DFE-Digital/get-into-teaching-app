import { Application } from 'stimulus';
import PageHelpfulController from 'page_helpful_controller';

describe('PageHelpfulController', () => {
  document.body.innerHTML = `
  <div id="pageHelpful" data-controller="page-helpful">
    <p id="text" data-page-helpful-target="text">Is this page helpful?</p>
    <a href="javascript:void(0)" id="answerButton" data-page-helpful-target="link" data-action="page-helpful#answer">Answer</a>
  </div>
  `;

  const application = Application.start();
  application.register('page-helpful', PageHelpfulController);
  const answerButton = document.getElementById('answerButton');

  describe('on connect', () => {
    it('displays the page helpful HTML', () => {
      const pageHelpful = document.getElementById('pageHelpful');
      expect(pageHelpful.classList).toContain('visible');
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
