import { Application } from 'stimulus';
import MailingListController from 'mailing-list_controller.js';
import StubLocalStorage from '../stubs/local_storage';

describe('MailingListController', () => {
  beforeEach(() => {
    document.body.innerHTML = `
      <div id="mailing-list-bar" class="mailing-list-bar" data-controller="mailing-list" data-banner-name="MailingList">
        <section class="container">
            <div class="mailing-list-bar__inner">
                <div class="mailing-list-bar__left">
                  Get personalised information and advice about getting into teaching
                </div>
                <div class="mailing-list-bar__right">
                  <a href="/mailinglist/signup" id="mailing-list-sign-up" class="mailing-list-bar__sign-up button button--white button--nowrap" data-action="click->mailing-list#beginMailingListJourney">Sign up <span>here</span></a>
                  <a href="" id="hide-mailing-list-bar" class="mailing-list-bar__close" data-action="click->mailing-list#dismiss">Not now</a>
                </div>
            </div>
        </section>
      </div>
    `;
  });

  describe('clicking hide', () => {
    beforeEach(() => {
      const application = Application.start();
      application.register('mailing-list', MailingListController);
    });

    it('hides the mailing-list bar', () => {
      const mailingListBar = document.getElementById('mailing-list-bar');
      const hideLink = document.getElementById('hide-mailing-list-bar');
      hideLink.click();
      expect(mailingListBar.style.display).toContain('none');
    });
  });

  describe("clicking 'Sign up now'", () => {
    beforeEach(() => {
      const application = Application.start();
      application.register('mailing-list', MailingListController);
    });

    it('hides the mailing-list bar', () => {
      const mailingListBar = document.getElementById('mailing-list-bar');
      const signUp = document.getElementById('mailing-list-sign-up');
      signUp.click();
      expect(mailingListBar.style.display).toContain('none');
    });
  });

  describe('when the user has visited fewer than 3 pages', () => {
    beforeEach(() => {
      window.localStorage.setItem('mailingListPageCount', '1');

      const application = Application.start();
      application.register('mailing-list', MailingListController);
    });

    it('the mailing list bar is never shown', () => {
      const mailingListBar = document.getElementById('mailing-list-bar');
      expect(mailingListBar.style.display).toEqual('');
    });
  });

  describe('when the user has visited 3 or more pages', () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', {
        value: new StubLocalStorage(),
      });
      window.localStorage.setItem('mailingListPageCount', '5');

      const application = Application.start();
      application.register('mailing-list', MailingListController);
    });

    it('shows the mailing list bar', () => {
      const mailingListBar = document.getElementById('mailing-list-bar');
      expect(mailingListBar.style.display).toContain('flex');
    });
  });

  describe('viewing a page increments the counter', () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', {
        value: new StubLocalStorage(),
      });
      window.localStorage.setItem('mailingListPageCount', '2');

      const application = Application.start();
      application.register('mailing-list', MailingListController);
    });

    it('the counter has increased by one', () => {
      const newCount = window.localStorage.getItem('mailingListPageCount');
      // the real localStorage would cast this to a String
      expect(newCount).toEqual(3);
    });
  });

  describe('dismissing the mailing list box', () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', {
        value: new StubLocalStorage({ mailingListPageCount: '2' }),
      });

      const application = Application.start();
      application.register('mailing-list', MailingListController);
    });

    it('the dismissed flag should be true', () => {
      const hideLink = document.getElementById('hide-mailing-list-bar');
      hideLink.click();

      const flag = window.localStorage.getItem('mailingListDismissed');
      expect(flag).toEqual('true');
    });
  });

  describe("once dismissed the mailing list bar shouldn't be shown", () => {
    beforeEach(() => {
      Object.defineProperty(window, 'localStorage', {
        value: new StubLocalStorage({
          mailingListDismissed: 'true',
          mailingListPageCount: '8',
        }),
      });

      const application = Application.start();
      application.register('mailing-list', MailingListController);
    });

    it("the mailing list bar shouldn't be shown", () => {
      const mailingListBar = document.getElementById('mailing-list-bar');

      expect(mailingListBar.style.display).toEqual('');
    });
  });
});
