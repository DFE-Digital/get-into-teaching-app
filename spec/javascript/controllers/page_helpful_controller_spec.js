import { Application } from 'stimulus' ;
import PageHelpfulController from 'page_helpful_controller';
import waitForExpect from 'wait-for-expect';

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
  const authenticity_token = "abc-123";

  const expectCall = (answer, url = window.location.href) => {
    expect(fetch.mock.calls.length).toEqual(2);
    
    const call = fetch.mock.calls[1];
    const path = call[0];
    const request = call[1];

    expect(path).toEqual("/feedback/page_helpful");
    expect(request.method).toEqual("POST");
    expect(request.headers).toEqual({ "Content-Type": "application/json" });
    expect(request.body).toEqual(JSON.stringify({ page_helpful: { url, answer: answer }, authenticity_token }));
  }

  beforeEach(() => {
    window.fetch.resetMocks();
    fetch.mockResponseOnce(JSON.stringify({ token: authenticity_token }))
  });

  describe("on connect", () => {
    it("displays the page helpful HTML", () => {
      const pageHelpful = document.getElementById("pageHelpful");
      expect(pageHelpful.style.display).toContain('block');
    });
  });

  describe("submitting an answer", () => {
    it("sends a 'yes' answer", async () => {
      yesButton.click();
      await waitForExpect(() => {
        expectCall("yes");
      });
    });

    it("sends a 'no' answer", async () => {
      noButton.click();
      await waitForExpect(() => {
        expectCall("no");
      });
    });

    it("does not send query parameters as part of the url attribute", async () => {
      Object.defineProperty(window, "location", {
        value: {
          href: "http://localhost/test?param=ignore"
        }
      });
      yesButton.click();
      await waitForExpect(() => {
        expectCall("yes", "http://localhost/test");
      });
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
