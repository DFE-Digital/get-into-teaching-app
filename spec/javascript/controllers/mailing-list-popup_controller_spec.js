import { Application } from 'stimulus' ;
import MailingListPopupController from 'mailing-list-popup_controller.js';
import StubLocalStorage from '../stubs/local_storage';

describe('MailingListPopupController', () => {
  beforeEach(() => {
    jest.useFakeTimers();

    Object.defineProperty(window, 'localStorage', {
      value: new StubLocalStorage({ mailingListDismissed: 'false' }),
    });

    document.body.innerHTML = `
    <div data-controller="mailing-list-popup" data-mailing-list-popup-target="modal" role="complementary">
      <div id="dialog" class="dialog" data-mailing-list-popup-target="dialog" style="display: none">
            <div class="dialog__buttons">
              <a href="/mailinglist/signup/name" class="button call-to-action-button" data-action="click->mailing-list-popup#accept">
                  <span>Register your interest</span>
              </a>
              <a class="button button--secondary" href="#" id="cookies-disagree" data-action="click->mailing-list-popup#dismiss">
                  <span>No thanks</span>
              </a>
            </div>
        </div>
    </div>
    ` ;
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

  const attachController = (touch = false) => {
    jest.resetModules();

    if (touch) {
      console.debug("mocking touch device");
      jest.mock('is-touch-device', () => ({ __esModule: true, default: () => true }));
    } else {
      console.debug("mocking desktop");
      jest.mock('is-touch-device', () => ({ __esModule: true, default: () => false }));
    }

    console.debug("mounting controller");
    const application = Application.start();
    application.register('mailing-list-popup', MailingListPopupController);
    dialog = document.getElementById('dialog');
  }

  beforeEach(() => {
    jest.resetModules();
  });

  describe("when the mailing list has already been dismissed", () => {
    beforeEach(() => {
      window.localStorage.setItem('mailingListDismissed', 'true');
      attachController();
    });

    it("does not display by default", () => {
      expect(dialog.style.display).toContain("none");
    });

    it("does not prompt on mouseleave", () => {
      mouseLeave();

      jest.advanceTimersByTime(100);
      expect(dialog.style.display).toContain("none");
    });
  });

  describe("when the mailing list popup has not been dismissed", () => {
    describe("on desktop", () => {
      beforeEach(() => {
        window.localStorage.setItem('mailingListDismissed', 'false')

        attachController();
      });

      it("prompts on mouseleave", () => {
        mouseLeave();
        jest.advanceTimersByTime(100);
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
        window.localStorage.setItem('mailingListDismissed', 'false')
        attachController(true);
      });

      it("prompts on long scroll to top", () => {
        longScrollToTop(1);
        jest.advanceTimersByTime(100); // Wait for timeout indicating scroll end.
        expect(dialog.style.display).toContain("flex");
      });
    });
  });
});
