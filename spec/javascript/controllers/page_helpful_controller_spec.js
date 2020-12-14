import { Application } from 'stimulus' ;
import PageHelpfulController from 'page_helpful_controller';

describe('PageHelpfulController', () => {
  document.body.innerHTML = `
  <div id="pageHelpful" data-controller="page-helpful">
    <p id="text" data-page-helpful-target="text">Is this page helpful?</p>
    <a href="javascript:void(0)" id="answerButton" data-page-helpful-target="link" data-action="page-helpful#answer">Answer</a>
  </div>
  ` ;

  const application = Application.start();
  application.register('page-helpful', PageHelpfulController);
  const answerButton = document.getElementById("answerButton");

  describe("on connect", () => {
    it("displays the page helpful HTML", () => {
      const pageHelpful = document.getElementById("pageHelpful");
      expect(pageHelpful.style.display).toContain('block');
    });
  });

  describe("submitting an answer", () => {
    it("hides the links", () => {
      answerButton.click();
      expect(answerButton.style.display).toContain('none');
    });

    it("displays a thank you message", () => {
      answerButton.click();
      expect(text.textContent).toEqual('Thank you for your feedback');
    });
  });
});
