const Cookies = require('js-cookie') ;
import CookiePreferences from 'cookie_preferences' ;
import { Application } from 'stimulus' ;
import LinkController from 'link_controller.js' ;

describe('LinkController', () => {
  function initPageTemplate() {
    document.body.innerHTML = `
    <div data-controller="link" data-target="link.content">
      <div id="level-1" class="video-overlay" data-target="video.player" data-action="click->video#close">
        <a href="#level-3" />
        <div id="level-2">
          <a href="#level-1" />
          <div id="level-3">
            <a href="#level-1" />
          </div>
        </div>
      </div>
    </div>`
  }

    describe("when first loaded", () => {
      
      it("adds data-turbolinks attribute to all jump links", () => {
        var linkNodes = document.getElementsByTagName("a");
        Object.keys(linkNodes).forEach(function (key) {
            expect(linkNodes[key].hasAttribute('data-turbolinks')).toBe(true);
        });
      });

      it("sets data-turbolinks attribute to value of false", () => {
        var linkNodes = document.getElementsByTagName("a");
        Object.keys(linkNodes).forEach(function (key) {
            expect(linkNodes[key][data-turbolinks]).toBe(false);
        });
      })

    });

});
