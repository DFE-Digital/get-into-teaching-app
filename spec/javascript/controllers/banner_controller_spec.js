import Cookies from 'js-cookie';
import { Application } from 'stimulus';
import BannerController from 'banner_controller';

describe('BannerController', () => {
  let banner;

  const setBannerHidden = (hidden) => {
    Cookies.set("GitBetaBannerName", hidden ? "Hidden" : null);
  }

  const registerController = () => {
    const application = Application.start();
    application.register('banner', BannerController);
    banner = document.getElementById('banner');
  }

  beforeEach(() => {
    document.body.innerHTML = `
      <div data-controller="banner" id="banner" data-banner-name-value="Name">
        <a href="#" id="hideButton" data-action="banner#hide">Hide</a>
      </div>
    `;
  })

  describe('when the cookie is not yet set', () => {
    beforeEach(() => {
      registerController(false)
    })

    it('shows the banner', () => {
      expect(banner.classList.contains('visible')).toBe(true);
    });

    describe('clicking the hide button', () => {
      it('hides the banner', () => {
        const hideButton = document.getElementById('hideButton');
        hideButton.click();
        expect(banner.classList.contains('visible')).toBe(false);
        expect(Cookies.get("GiTBetaBannerName")).toEqual("Hidden")
      });
    });
  });

  describe('when the cookie has been set', () => {
    beforeEach(() => {
      setBannerHidden(true)
      registerController(true)
    });

    it('hides the banner', () => {
      expect(banner.classList.contains('visible')).toBe(false);
    });
  });
});
