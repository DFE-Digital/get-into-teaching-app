import { Application } from 'stimulus' ;
import BannerController from 'banner_controller';

describe('BannerController', () => {
  document.body.innerHTML = `
  <div data-controller="banner" id="banner" data-banner-name="Name">
    <a href="#" id="hideButton" data-action="banner#hide">Hide</a>
  </div>
  ` ;

  const application = Application.start();
  application.register('banner', BannerController);
  const banner = document.getElementById('banner');

  describe("when the cookie is not yet set", () => {
    it("shows the banner", () => {
      expect(banner.style.display).not.toContain('none');
    });

    describe("clicking the hide button", () => {
      it("hides the banner", () => {
        var hideButton = document.getElementById('hideButton');
        hideButton.click();
        expect(banner.style.display).toContain('none');
      });
    });
  });

  describe("when the cookie has been set", () => {
    beforeEach(() => { document.cookie = "GiTBetaBannerName=Hidden"; });

    it('hides the banner', () => {
      expect(banner.style.display).toContain('none');
    });
  });
})
