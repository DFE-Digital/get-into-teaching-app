const Cookies = require('js-cookie') ;
import CookiePreferences from 'cookie_preferences' ;
import { Application } from 'stimulus' ;

describe('FeedbackPromptController', () => {
  var dialog;
  var application;

  beforeEach(() => {
    jest.useFakeTimers();

    Cookies.remove(CookiePreferences.cookieName) ;
    Cookies.remove('GiTBetaFeedbackPrompt') ;

    console.error = jest.fn();
    document.body.innerHTML = `
    <div data-controller="feedback-prompt">
      <div id="dialog" data-target="feedback-prompt.dialog" style="display: none;">
        <a href="#" id="actionButton" data-action="feedback-prompt#disable">Close</a>
        <a href="#" id="closeButton" data-action="feedback-prompt#close feedback-prompt#disable">Close</a>
      </div>
    </div>
    ` ;
  
    application = Application.start();
  });

  const mouseLeave = (clientY = 0) => {
    var mouseEvent = document.createEvent("MouseEvents");
    mouseEvent.initMouseEvent("mouseleave", true, false, window, 0, 0, 0, 0, clientY);
    document.documentElement.dispatchEvent(mouseEvent);
  };

  const longScrollToTop = (distance = 700, end = 0) => {
    window.pageYOffset = distance + end;
    const scrollEvent = new Event('scroll');
    window.dispatchEvent(scrollEvent);
    window.pageYOffset = end;
  };

  const attachController = (bypassDelay = false) => {
    jest.resetModules();
    application.register('feedback-prompt', require("feedback_prompt_controller").default);
    dialog = document.getElementById('dialog');

    if (bypassDelay) {
      jest.advanceTimersByTime(21000);
    }
  }

  const mockTouchDevice = () => {
    jest.mock('is-touch-device', () => ({ __esModule: true, default: () => true }));
  };

  const mockDesktop = () => {
    jest.mock('is-touch-device', () => ({ __esModule: true, default: () => false }));
  };

  describe("when cookies have been accepted", () => {
    beforeEach(() => { 
      (new CookiePreferences).allowAll() ;
    });

    it("does not display by default", () => {
      attachController();
      expect(dialog.style.display).toContain("none");
    });

    describe("when the delay time has not yet passed", () => {
      beforeEach(() => {
        mockDesktop();
        attachController(false);
      });

      it("does not prompt", () => {
        mouseLeave();
        expect(dialog.style.display).toContain("none");
      });
    });

    describe("when the delay time has passed", () => {
      describe("on desktop", () => {
        beforeEach(() => {
          mockDesktop();
          attachController(true);
        });
  
        it("prompts on mouseleave", () => {
          mouseLeave();
          expect(dialog.style.display).toContain("flex");
        });
    
        it("prompts according to the sensitivity value", () => {
          mouseLeave(1);
          expect(dialog.style.display).toContain("none");
          mouseLeave(0);
          expect(dialog.style.display).toContain("flex");
        });
      });
  
      describe("on a touch device", () => {
        beforeEach(() => {
          mockTouchDevice();
          attachController(true);
        });
  
        it("prompts on long scroll to top", () => {
          longScrollToTop();
          jest.advanceTimersByTime(100); // Wait for timeout indicating scroll end.
          expect(dialog.style.display).toContain("flex");
        });
  
        it("prompts according to the distance sensitivity value", () => {
          longScrollToTop(699);
          jest.advanceTimersByTime(100); // Wait for timeout indicating scroll end.
          expect(dialog.style.display).toContain("none");
          longScrollToTop(701);
          jest.advanceTimersByTime(100); // Wait for timeout indicating scroll end.
          expect(dialog.style.display).toContain("flex");
        });
  
        it("prompts according to the end sensitivity value", () => {
          longScrollToTop(700, 301);
          jest.advanceTimersByTime(100); // Wait for timeout indicating scroll end.
          expect(dialog.style.display).toContain("none");
          longScrollToTop(700, 299);
          jest.advanceTimersByTime(100); // Wait for timeout indicating scroll end.
          expect(dialog.style.display).toContain("flex");
        });
      });
  
      describe("clicking the close button", () => {
        beforeEach(() => {
          mockDesktop();
          attachController(true);
          mouseLeave();
          expect(dialog.style.display).toContain("flex");
          const closeButton = document.getElementById('closeButton');
          closeButton.click();
        });
  
        it("closes the dialog", () => {
          expect(dialog.style.display).toContain("none");
        });
  
        it("set the cookie", () => {
          expect(Cookies.get('GiTBetaFeedbackPrompt')).toEqual("Disabled");
        });
      });
  
      describe("clicking the action button", () => {
        beforeEach(() => {
          mockDesktop();
          attachController(true);
          mouseLeave();
          expect(dialog.style.display).toContain("flex");
          const actionButton = document.getElementById('actionButton');
          actionButton.click();
        });
  
        it("set the cookie", () => {
          expect(Cookies.get('GiTBetaFeedbackPrompt')).toEqual("Disabled");
        });
      });
    });
  });

  describe("when the prompt has already been seen", () => {
    beforeEach(() => { 
      (new CookiePreferences).allowAll() ;
      Cookies.set('GiTBetaFeedbackPrompt', 'Disabled') ;
    });

    it("no longer prompts", () => {
      mockDesktop();
      attachController();
      mouseLeave();
      expect(dialog.style.display).toContain("none");
    });
  });

  describe("when the prompt has already been actioned", () => {
    beforeEach(() => { 
      (new CookiePreferences).allowAll() ;
      Cookies.set('GiTBetaFeedbackPrompt', 'Disabled', { expires: 365 }) ;
    });

    it("no longer prompts", () => {
      mockDesktop();
      attachController();
      mouseLeave();
      expect(dialog.style.display).toContain("none");
    });
  });
})
