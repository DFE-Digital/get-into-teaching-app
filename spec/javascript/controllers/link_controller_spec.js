import { Application } from 'stimulus';
import LinkController from 'link_controller.js';

describe('LinkController', () => {
  describe('making external links open in new windows', () => {
    beforeEach(() => {
      document.body.innerHTML = `
      <div data-controller="link" data-link-target="content" data-link-assets-url-value="https://assets-url.com">
        <div class="content">
          <a id="content-external-link" href="https://www.sample.com/content-link">Content external link</a>
          <a id="content-internal-link" href="/internal-link">Content internal link</a>
          <a id="content-anchor-link" href="#subheading">Content anchor link</a>
          <a id="asset-link" href="https://assets-url.com/doc.pdf">Content PDF link</a>
        </div>
        <a href="https://www.sample.com/non-content-link">Non-content link</a>
        <a href="https://www.sample.com/another-non-content-link">Another non-content link</a>
      </div>`;
    });

    beforeEach(() => {
      const application = Application.start();
      application.register('link', LinkController);
    });

    describe('when loaded', () => {
      it("adds target='_blank' to the content external link", () => {
        const contentExternalLink = document.getElementById(
          'content-external-link'
        );
        expect(contentExternalLink.getAttribute('target')).toEqual('_blank');
      });

      it("adds rel='noopener' to the content external link", () => {
        const contentExternalLink = document.getElementById(
          'content-external-link'
        );
        expect(contentExternalLink.getAttribute('rel')).toEqual(
          'noopener'
        );
      });

      it('adds a description of where the link will open for screen reader users', () => {
        const hiddenText = document.querySelector(
          'a#content-external-link > span'
        );
        expect(hiddenText.textContent).toEqual('(Link opens in new window)');
      });

      it("doesn't add target='_blank' to links to assets", () => {
        const assetLink = document.getElementById('asset-link');
        expect(assetLink.hasAttribute('target')).toBe(false);
      });

      it("doesn't add target='_blank' to links to internal paths", () => {
        const linkNodes = [...document.getElementsByTagName('a')];

        linkNodes
          .filter((link) => !link.href.startsWith('http'))
          .forEach((link) => {
            expect(link.hasAttribute('target')).toBe(false);
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
