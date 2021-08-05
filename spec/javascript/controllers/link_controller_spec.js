import { Application } from 'stimulus';
import LinkController from 'link_controller.js';

describe('LinkController', () => {
  // describe('disabling turbolinks for links containing anchors', () => {
  //   beforeEach(() => {
  //     document.body.innerHTML = `
  //     <div data-controller="link" data-link-target="content">
  //       <a href="path/to#position">Jump Link</a>
  //       <div id="level-1" class="video-overlay" data-video-target="player" data-action="click->video#close">
  //         <a href="#level-3" />
  //         <div id="level-2">
  //           <a href="#level-1" />
  //           <div id="level-3">
  //             <a href="#level-1" />
  //           </div>
  //         </div>
  //       </div>
  //     </div>`;
  //   });

  //   beforeEach(() => {
  //     const application = Application.start();
  //     application.register('link', LinkController);
  //   });

  //   describe('when first loaded', () => {
  //     it('adds data-turbolinks attribute to all jump links', () => {
  //       const linkNodes = [...document.getElementsByTagName('a')];

  //       linkNodes.forEach((link) => {
  //         expect(link.hasAttribute('data-turbolinks')).toBe(true);
  //       });
  //     });

  //     it('sets data-turbolinks attribute to value of false', () => {
  //       const linkNodes = [...document.getElementsByTagName('a')];

  //       linkNodes.forEach((link) => {
  //         expect(link.getAttribute('data-turbolinks')).toEqual('false');
  //       });
  //     });
  //   });
  // });

  describe('making external links open in new windows', () => {
    beforeEach(() => {
      document.body.innerHTML = `
      <div data-controller="link" data-link-target="content">
        <div class="content">
          <a id="content-external-link" href="https://www.sample.com/content-link">Content external link</a>
          <a id="content-internal-link" href="/internal-link">Content internal link</a>
          <a id="content-anchor-link" href="#subheading">Content anchor link</a>
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

      it("adds rel='noopener noreferrer' to the content external link", () => {
        const contentExternalLink = document.getElementById(
          'content-external-link'
        );
        expect(contentExternalLink.getAttribute('rel')).toEqual(
          'noopener noreferrer'
        );
      });

      it('adds a description of where the link will open for screen reader users', () => {
        const hiddenText = document.querySelector(
          'a#content-external-link > span'
        );
        expect(hiddenText.textContent).toEqual('(Link opens in new window)');
      });

      it("doesn't add target='_blank' to any other links", () => {
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
