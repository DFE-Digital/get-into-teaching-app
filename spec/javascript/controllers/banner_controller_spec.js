import Cookies from 'js-cookie';
import { Application } from 'stimulus';
import BannerController from 'banner_controller';

describe('BannerController', () => {
  document.body.innerHTML = `
  <div data-controller="banner" id="banner" data-banner-name="Name">
    <a href="#" id="hideButton" data-action="banner#hide">Hide</a>
  </div>
  `;

  let banner = '';

  beforeEach(() => {
    Cookies.remove('GiTBetaBannerName');

    const application = Application.start();
    application.register('banner', BannerController);
    banner = document.getElementById('banner');
  });

  describe('when the cookie is not yet set', () => {
    it('shows the banner', () => {
      expect(banner.style.display).not.toContain('none');
    });

    describe('clicking the hide button', () => {
      it('hides the banner', () => {
        const hideButton = document.getElementById('hideButton');
        hideButton.click();
        expect(banner.style.display).toContain('none');
      });
    });
  });

  describe('when the cookie has been set', () => {
    beforeEach(() => {
      Cookies.set("GiTBetaBannerName', 'Hidden");
    });

    it('hides the banner', () => {
      expect(banner.style.display).toContain('none');
    });
  });
});
