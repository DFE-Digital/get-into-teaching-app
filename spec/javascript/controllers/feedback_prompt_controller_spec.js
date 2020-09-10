import { Application } from 'stimulus' ;
import FeedbackPromptController from 'feedback_prompt_controller';

describe('FeedbackPromptController', () => {
  var dialog;

  beforeEach(() => {
    document.body.innerHTML = `
    <div data-controller="feedback-prompt">
      <div id="dialog" data-target="feedback-prompt.dialog" style="display: none;">
        <a href="#" id="actionButton" data-action="feedback-prompt#disable">Close</a>
        <a href="#" id="closeButton" data-action="feedback-prompt#close feedback-prompt#disable">Close</a>
      </div>
    </div>
    ` ;
  
    const application = Application.start();
    application.register('feedback-prompt', FeedbackPromptController);
    dialog = document.getElementById('dialog');
  });

  const mouseLeave = (clientY = 0) => {
    var mouseEvent = document.createEvent("MouseEvents");
    mouseEvent.initMouseEvent("mouseleave", true, false, window, 0, 0, 0, 0, clientY);
    document.documentElement.dispatchEvent(mouseEvent);
  };

  const setCookie = (cookie) => {
    Object.defineProperty(window.document, 'cookie', {
      writable: true,
      value: cookie
    });
  };

  describe("when cookies have not been accepted", () => {
    it("does not prompt on mouseleave", () => {
      mouseLeave();
      expect(dialog.style.display).toContain("none");
    });
  });

  describe("when cookies have been accepted", () => {
    beforeEach(() => { 
      setCookie('GiTBetaCookie=Accepted')
    });

    it("does not display by default", () => {
      expect(dialog.style.display).toContain("none");
    });

    it("prompts on mouseleave", () => {
      mouseLeave();
      expect(dialog.style.display).toContain("flex");
    });

    it("prompts according to the sensitivity value", () => {
      mouseLeave(21);
      expect(dialog.style.display).toContain("none");
      mouseLeave(19);
      expect(dialog.style.display).toContain("flex");
    });

    describe("clicking the close button", () => {
      beforeEach(() => {
        mouseLeave();
        expect(dialog.style.display).toContain("flex");
        const closeButton = document.getElementById('closeButton');
        closeButton.click();
      });

      it("closes the dialog", () => {
        expect(dialog.style.display).toContain("none");
      });

      it("set the cookie with an expiry date", () => {
        expect(document.cookie).toContain("GiTBetaFeedbackPrompt=Disabled; expires=");
      });
    });

    describe("clicking the action button", () => {
      beforeEach(() => {
        mouseLeave();
        expect(dialog.style.display).toContain("flex");
        const actionButton = document.getElementById('actionButton');
        actionButton.click();
      });

      it("set the cookie with an expiry date", () => {
        expect(document.cookie).toContain("GiTBetaFeedbackPrompt=Disabled; expires=");
      });
    });
  });

  describe("when the prompt has already been seen", () => {
    beforeEach(() => { 
      setCookie('GiTBetaCookie=Accepted;GiTBetaFeedbackPrompt=Disabled')
    });

    it("no longer prompts on mouseleave", () => {
      mouseLeave();
      expect(dialog.style.display).toContain("none");
    });
  });

  describe("when the prompt has already been actioned", () => {
    beforeEach(() => { 
      var expiry = new Date();
      expiry.setFullYear(expiry.getFullYear() + 1);
      setCookie(`GiTBetaCookie=Accepted;GiTBetaFeedbackPrompt=Disabled; expires=${expiry.toUTCString()}`)
    });

    it("no longer prompts on mouseleave", () => {
      mouseLeave();
      expect(dialog.style.display).toContain("none");
    });
  });
})
