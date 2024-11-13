import { Application } from '@hotwired/stimulus';
import LinkController from 'link_controller.js';

describe('LinkController', () => {
  describe('disabling turbolinks for links containing anchors', () => {
    beforeEach(() => {
      document.body.innerHTML = `
      <div data-controller="link" data-link-target="content">
        <a href="path/to#position">Jump Link</a>
        <div id="level-1">
          <a href="#level-3" />
          <div id="level-2">
            <a href="#level-1" />
            <div id="level-3">
              <a href="#level-1" />
            </div>
          </div>
        </div>
      </div>`;
    });

    beforeEach(() => {
      const application = Application.start();
      application.register('link', LinkController);
    });

    describe('when first loaded', () => {
      it('adds data-turbolinks attribute to all jump links', () => {
        const linkNodes = [...document.getElementsByTagName('a')];

        linkNodes.forEach((link) => {
          expect(link.hasAttribute('data-turbolinks')).toBe(true);
        });
      });

      it('sets data-turbolinks attribute to value of false', () => {
        const linkNodes = [...document.getElementsByTagName('a')];

        linkNodes.forEach((link) => {
          expect(link.getAttribute('data-turbolinks')).toEqual('false');
        });
      });
    });
  });

  describe('wrapping the last button in a span', () => {
    beforeEach(() => {
      document.body.innerHTML = `
      <div data-controller="link" data-link-target="content">
        <h2>should be affected:</h2>
        <a id="one" href="#" class="button">The quick</a>
        <a id="two" href="#" class="button">brown fox jumped</a>
        <a id="three" href="#" class="type-description__link">over the lazy</a>
        <a id="four" href="#" class="type-description__link">fox</a>

        <h2>should not be affected:</h2>

        <p>(doesn't match the class)</p>
        <a id="five" href="#" class="other">The quick brown</a>

        <p>(already contains a span)</p>
        <a id="six" href="#" class="other">Jumped <span>over the lazy</span></a>
      </div>`;
    });

    beforeEach(() => {
      const application = Application.start();
      application.register('link', LinkController);
    });

    describe('when loaded', () => {
      it('wraps the last word in a span', () => {
        const span1 = document.querySelector('a#one > span');
        expect(span1.textContent).toEqual('quick');

        const span2 = document.querySelector('a#two > span');
        expect(span2.textContent).toEqual('jumped');

        const span3 = document.querySelector('a#three > span');
        expect(span3.textContent).toEqual('lazy');

        const span4 = document.querySelector('a#four > span');
        expect(span4.textContent).toEqual('fox');
      });

      it("doesn't affect non .button/.type-description__link links", () => {
        const span5 = document.querySelector('a#five > span');
        expect(span5).toBeNull();

        const span6 = document.querySelector('a#six > span');
        expect(span6.textContent).toEqual('over the lazy');
      });
    });
  });
});
