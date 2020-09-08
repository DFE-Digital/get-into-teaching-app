import { Application } from 'stimulus' ;
import BannerController from 'banner_controller';

describe('BannerController', () => {
  document.body.innerHTML = `
  <div data-controller="banner" id="banner">
    <a href="#" id="hideButton" data-action="banner#hide">Hide</a>
  </div>
  ` ;

  const application = Application.start();
  application.register('banner', BannerController);

  describe("clicking the hide button", () => {
    it("hides the banner", () => {
      var hideButton = document.getElementById('hideButton');
      var banner = document.getElementById('banner');
      hideButton.click();
      expect(banner.style.display).toContain('none');
    });
  });
})
