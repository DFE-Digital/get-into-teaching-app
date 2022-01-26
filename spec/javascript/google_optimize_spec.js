import GoogleOptimize from 'google_optimize';
import Cookies from 'js-cookie';
import CookiePreferences from 'cookie_preferences';

describe('Google Optimize', () => {
  let optimize;
  const optimizeId = 'ABC-123';
  const experimentPath = '/experiment';

  const clearCookies = () => {
    Cookies.remove(CookiePreferences.cookieName);
  };

  const setupHtml = () => {
    document.body.className = '';
    document.head.innerHTML = `<script></script>`;
    document.body.innerHTML = `
      <div class="cookie-acceptance">
        <div class="dialog__background"></div>
      </div>`;
  };

  const run = (path) => {
    window.location.pathname = path;
    optimize = new GoogleOptimize(optimizeId, [experimentPath]);
    optimize.init();
    document.dispatchEvent(new Event('DOMContentLoaded'));
  };

  const mockWindowLocation = () => {
    Object.defineProperty(window, 'location', {
      configurable: true,
      value: { hostname: 'localhost', reload: jest.fn() },
    });
  };

  const dispatchBeforeVisit = (url) => {
    const event = new CustomEvent('turbo:before-visit', {
      detail: { url: url },
    });
    document.dispatchEvent(event);
  };

  const setGoogleOptimizeRedirectLoopCookie = () => {
    Cookies.set('_gaexp_rc', '1');
  };

  beforeEach(() => {
    jest.useFakeTimers();
    clearCookies();
    setupHtml();
    mockWindowLocation();
    setGoogleOptimizeRedirectLoopCookie();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  afterEach(() => {
    optimize.dispose();
    window.location.reload.mockClear();
  });

  describe('when cookies have not yet been accepted', () => {
    describe('when on an experiment path', () => {
      beforeEach(() => run(experimentPath));

      it('clears the _gaexp_rc cookie', () => {
        expect(Cookies.get('_gaexp_rc')).toBeUndefined();
      });

      it('blurs the cookie acceptance background to obscure the content', () => {
        expect(
          document.querySelector('.cookie-acceptance .dialog__background')
        ).toBeNull();
        expect(document.body.classList.contains('blur')).toBe(true);
        expect(document.querySelector('.optimize-overlay')).not.toBeNull();
      });

      it('does not append the Google Optimize script to the head', () => {
        expect(
          document.head.querySelector(
            'script[src^="https://www.googleoptimize.com"]'
          )
        ).toBeNull();
      });

      describe('when cookies are accepted', () => {
        it('reloads the page', () => {
          new CookiePreferences().setCategories({
            [GoogleOptimize.cookieCategory]: true,
          });
          expect(window.location.reload).toHaveBeenCalled();
        });
      });
    });

    describe('when not on an experiment path', () => {
      beforeEach(() => run('/no-experiment'));

      it('clears the _gaexp_rc cookie', () => {
        expect(Cookies.get('_gaexp_rc')).toBeUndefined();
      });

      it('does not blur the cookie acceptance background', () => {
        expect(
          document.querySelector('.cookie-acceptance .dialog__background')
        ).not.toBeNull();
        expect(document.body.classList.contains('blur')).toBe(false);
        expect(document.querySelector('.optimize-overlay')).toBeNull();
      });

      it('does not deploy the anti-flicker fix', () => {
        expect(document.querySelector('.anti-flicker')).toBeNull();
      });

      it('does not append the Google Optimize script to the head', () => {
        expect(
          document.head.querySelector(
            'script[src^="https://www.googleoptimize.com"]'
          )
        ).toBeNull();
      });

      describe('when cookies are accepted', () => {
        it('does not reload the page', () => {
          new CookiePreferences().setCategories({
            [GoogleOptimize.cookieCategory]: true,
          });
          expect(window.location.reload).not.toHaveBeenCalled();
        });
      });
    });
  });

  describe('when cookies have already been accepted', () => {
    beforeEach(() => {
      new CookiePreferences().setCategories({ 'non-functional': true });
    });

    describe('when on an experiment path', () => {
      beforeEach(() => run(experimentPath));

      it('clears the _gaexp_rc cookie', () => {
        expect(Cookies.get('_gaexp_rc')).toBeUndefined();
      });

      it('does not blur the cookie acceptance background', () => {
        expect(
          document.querySelector('.cookie-acceptance .dialog__background')
        ).not.toBeNull();
        expect(document.body.classList.contains('blur')).toBe(false);
        expect(document.querySelector('.optimize-overlay')).toBeNull();
      });

      it('deploys the anti-flicker fix', () => {
        expect(document.querySelector('.anti-flicker')).not.toBeNull();
      });

      it('appends the Google Optimize script to the head', () => {
        expect(
          document.head.querySelector(
            `script[src^="https://www.googleoptimize.com/optimize.js?id=${optimizeId}"]`
          )
        ).not.toBeNull();
      });

      it('removes the anti-flicker script when Google Optimize is ready/times out', () => {
        jest.runAllTimers();
        expect(document.querySelector('.anti-flicker')).toBeNull();
      });
    });

    describe('when not on an experiment path', () => {
      beforeEach(() => run('/no-experiment'));

      it('clears the _gaexp_rc cookie', () => {
        expect(Cookies.get('_gaexp_rc')).toBeUndefined();
      });

      it('does not append the Google Optimize script to the head', () => {
        expect(
          document.head.querySelector(
            'script[src^="https://www.googleoptimize.com"]'
          )
        ).toBeNull();
      });

      describe('when Turbo transitions to an experiment path', () => {
        beforeEach(() =>
          dispatchBeforeVisit(`https://test.com${experimentPath}`)
        );

        it('hijacks the transition and performs a full load of the page', () => {
          expect(window.location.href).toEqual(
            `https://test.com${experimentPath}`
          );
        });
      });

      describe('when Turbo transitions to a non-experiment path', () => {
        beforeEach(() => dispatchBeforeVisit('https://test.com/no-experiment'));

        it('does not hijack the transition', () => {
          // The window.location.href is manually changed when we hijack the
          // transition; this checks that it has not changed yet.
          expect(window.location.href).toEqual(
            `https://test.com${experimentPath}`
          );
        });
      });
    });
  });

  describe('when cookies have been accepted but the category was not opted-in to', () => {
    beforeEach(() => {
      new CookiePreferences().setCategories({ marketing: true });
    });

    describe('when on an experiment path', () => {
      beforeEach(() => run(experimentPath));

      it('clears the _gaexp_rc cookie', () => {
        expect(Cookies.get('_gaexp_rc')).toBeUndefined();
      });

      it('does not blur the cookie acceptance background', () => {
        expect(
          document.querySelector('.cookie-acceptance .dialog__background')
        ).not.toBeNull();
        expect(document.body.classList.contains('blur')).toBe(false);
        expect(document.querySelector('.optimize-overlay')).toBeNull();
      });

      it('does not deploy the anti-flicker fix', () => {
        expect(document.querySelector('.anti-flicker')).toBeNull();
      });

      it('does not append the Google Optimize script to the head', () => {
        expect(
          document.head.querySelector(
            'script[src^="https://www.googleoptimize.com"]'
          )
        ).toBeNull();
      });
    });
  });
});
