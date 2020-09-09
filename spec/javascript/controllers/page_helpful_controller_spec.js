import { Application } from 'stimulus' ;
import PageHelpfulController from 'page_helpful_controller';

describe('PageHelpfulController', () => {
  document.body.innerHTML = `
  <div id="pageHelpful" data-controller="page-helpful">
    <p id="text" data-target="page-helpful.text">Is this page helpful?</p>
    <a href="javascript:void(0)" id="yesButton" data-target="page-helpful.link" data-action="page-helpful#yes">Yes</a>
    <a href="javascript:void(0)" id="noButton" data-target="page-helpful.link" data-action="page-helpful#no">No</a>
  </div>
  ` ;

  const application = Application.start();
  application.register('page-helpful', PageHelpfulController);
  const yesButton = document.getElementById("yesButton");
  const noButton = document.getElementById("noButton");

  const expectCall = (answer, url = window.location.href) => {
    expect(fetch.mock.calls.length).toEqual(1);

    const call = fetch.mock.calls[0];
    const path = call[0];
    const request = call[1];

    expect(path).toEqual("/feedback/page_helpful");
    expect(request.method).toEqual("POST");
    expect(request.headers).toEqual({ "Content-Type": "application/json" });
    expect(request.body).toEqual(JSON.stringify({ page_helpful: { url, answer: answer }}));
  }

  beforeEach(() => {
    window.fetch.resetMocks();
  });

  describe("on connect", () => {
    it("displays the page helpful HTML", () => {
      const pageHelpful = document.getElementById("pageHelpful");
      expect(pageHelpful.style.display).toContain('block');
    });
  });

  describe("submitting an answer", () => {
    it("sends a 'yes' answer", () => {
      yesButton.click();
      expectCall("yes");
    });

    it("sends a 'no' answer", () => {
      noButton.click();
      expectCall("no");
    });

    it("does not send query parameters as part of the url attribute", () => {
      Object.defineProperty(window, "location", {
        value: {
          href: "http://localhost/test?param=ignore"
        }
      });
      yesButton.click();
      expectCall("yes", "http://localhost/test");
    });

    it("disables the links when clicked", () => {
      yesButton.click();
      expect(yesButton.disabled).toBeTruthy();
      expect(noButton.disabled).toBeTruthy();
    });

    describe("when successfully submitted", () => {
      beforeEach(() => fetch.mockResponseOnce());

      it("hides the links", () => {
        yesButton.click();
        expect(yesButton.style.display).toContain('none');
        expect(noButton.style.display).toContain('none');
      });
  
      it("displays a thank you message", () => {
        yesButton.click();
        expect(text.textContent).toEqual('Thank you for your feedback');
      });
    });

    describe("when an error occurs", () => {
      beforeEach(() => fetch.mockRejectOnce());

      it("hides the links", () => {
        yesButton.click();
        expect(yesButton.style.display).toContain('none');
        expect(noButton.style.display).toContain('none');
      });
  
      it("displays an error message", () => {
        yesButton.click();
        expect(text.textContent).toContain('Sorry, the response did not send successfully.');
      });
    });
  });
});
