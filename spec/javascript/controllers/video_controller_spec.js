import Cookies from 'js-cookie';
import CookiePreferences from 'cookie_preferences';
import { Application } from 'stimulus';
import VideoController from 'video_controller.js';

describe('AccordionController', () => {
  const iframeFocusMock = jest.fn();

  function initPageTemplate() {
    document.body.innerHTML = `
    <div data-controller="video">
        <a href="https://www.youtube.com/watch?v=MLdrZJpK5rU" target="_blank rel="noopener"" data-action="click->video#play" data-video-target="link">
            <div class="content-video">
                <img src="media/images/content/case-study-helen.png" alt="Helen's story">
                <div class="content-video__play">
                    <div class="icon-play"></div>
                </div>
            </div>
        </a>
        <div id="the-video-player" class="video-overlay" data-video-target="player" data-action="click->video#close">
            <div class="video-overlay__background">
            </div>
            <div class='video-overlay__video-container'>
                <div class="video-overlay__video-container__wrapper">
                    <iframe data-video-target="iframe"
                        width="800"
                        height="450"
                        src=""
                        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen>
                    </iframe>
                </div>
                <button id="close-button" class="video-overlay__video-container__dismiss" data-video-target="close" data-action="click->video#close">
                    <div class="icon-video-close"><span class="visually-hidden">Close video</span></div>
                </button>
                <a class="visually-hidden" href="#">
                    Close
                </a>
            </div>
        </div>
    </div>`;
  }

  function initCookies() {
    const data = JSON.stringify({ functional: true, 'non-functional': true });
    Cookies.set('git-cookie-preferences-v1', data);
  }

  function mockIframeFocus() {
    iframeFocusMock.mockClear();
    VideoController.prototype.focusIframeWindow = iframeFocusMock;
  }

  function acceptCookies() {
    new CookiePreferences().allowAll();
  }

  function initApp() {
    initPageTemplate();
    const application = Application.start();
    application.register('video', VideoController);
  }

  beforeEach(() => {
    mockIframeFocus();
    Cookies.remove('git-cookie-preferences-v1');
  });

  describe('when cookies already accepted', () => {
    beforeEach(() => {
      initCookies();
      initApp();
    });

    describe('when first loaded', () => {
      it('removes the target attribute from video links', () => {
        const vidlink = document.getElementsByTagName('a');
        expect(vidlink[0].getAttribute('target')).toBe(null);
      });

      it('sets the video player as enabled', () => {
        const overlay = document.querySelector('[data-video-target="player"');
        expect(overlay.classList.contains('playback-enabled')).toBe(true);
      });
    });

    describe('when video link is clicked', () => {
      beforeEach(() => {
        const vidlink = document.getElementsByTagName('a')[0];
        vidlink.click();
      });

      it('swaps out the youtube url with the embedded version', () => {
        const iframe = document.getElementsByTagName('iframe')[0];
        const iframesrc = iframe.getAttribute('src');
        expect(iframesrc).toContain('https://www.youtube.com/embed/');
      });

      it('makes the video player visible', () => {
        const videoplayer = document.getElementById('the-video-player');
        expect(videoplayer.style.display).toBe('flex');
      });

      it('focuses on the video player iframe', () => {
        expect(iframeFocusMock).toHaveBeenCalled();
      });
    });

    describe('when the dismiss button is clicked', () => {
      it('sets the video player display to hidden', () => {
        const closeButton = document.getElementById('close-button');
        closeButton.click();
        const videoplayer = document.getElementById('the-video-player');
        expect(videoplayer.style.display).toBe('none');
      });
    });

    describe('when the overlay is clicked and video is open', () => {
      it('sets the video player display to hidden', () => {
        const vidlink = document.getElementsByTagName('a')[0];
        vidlink.click();
        const videoplayer = document.getElementById('the-video-player');
        videoplayer.click();
        expect(videoplayer.style.display).toBe('none');
      });
    });
  });

  describe('when cookies no existing', () => {
    beforeEach(() => {
      initApp();
    });

    it('does not enable in page playback', () => {
      const overlay = document.querySelector('[data-video-target="player"');
      expect(overlay.classList.contains('playback-enabled')).toBe(false);
    });

    it('leaves iframe src blank when video link is clicked', () => {
      document.querySelector('a[data-video-target="link"]').click();

      const iframe = document.querySelector('iframe');
      expect(iframe.getAttribute('src')).toEqual('');
    });
  });

  describe('when cookies accepted after page has loaded', () => {
    beforeEach(() => {
      initApp();
      acceptCookies();
    });

    it('does enable in-page playback', () => {
      const overlay = document.querySelector('[data-video-target="player"');
      expect(overlay.classList.contains('playback-enabled')).toBe(true);
    });

    it('sets the iframe src when video link is clicked', () => {
      document.querySelector('a[data-video-target="link"]').click();

      const iframeSrc = document.querySelector('iframe').getAttribute('src');
      expect(iframeSrc).toMatch(/youtube/);
      expect(iframeSrc).toMatch(/MLdrZJpK5rU/);
    });
  });
});
