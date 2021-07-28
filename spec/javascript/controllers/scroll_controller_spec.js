import { Application } from 'stimulus';
import ScrollController from 'scroll_controller';

describe('ScrollController', () => {
  let application;

  beforeEach(() => {
    document.body.innerHTML = `<div id="controller" data-controller="scroll" style="height: 10000px;">
        <div style="height: 5000px;"></div>
        <a id="link" href="/path" data-action="click->scroll#preserve">Link</a>
      </div>`;

    application = Application.start();
  });

  describe('arriving on a page after preserving the scroll position', () => {
    it('restores the scroll position', () => {
      window.localStorage.setItem(ScrollController.previousTopKey, '7000');
      window.scrollTo = jest.fn();

      application.register('scroll', ScrollController);

      expect(window.scrollTo).toHaveBeenCalledWith(0, '7000');
      expect(
        window.localStorage.getItem(ScrollController.previousTopKey)
      ).toBeNull();
    });
  });

  describe('clicking on an element that preserves the scroll position', () => {
    it('records the scroll position', () => {
      application.register('scroll', ScrollController);

      // The browser will set this on click, but Jest doesn't
      // so we need to set it manually.
      document.documentElement.scrollTop = '5000';

      const link = document.getElementById('link');
      link.click();

      expect(
        window.localStorage.getItem(ScrollController.previousTopKey)
      ).toEqual('5000');
    });
  });
});
