import AnalyticsHelper from './analytics_spec_helper';
import GoogleOptimizeController from 'google_optimize_controller';
import { expectation } from 'sinon';

describe('GoogleOptimizeController', () => {
  document.head.innerHTML = `<script></script>`;
  document.body.innerHTML = `<div data-controller="google-optimize"></div>`;
  document.body.setAttribute('data-google-optimize-id', 'OP-456');

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => {
    delete window.optimize;
  });

  describe('when visiting a path that runs an experiment', () => {
    beforeEach(() => {
      GoogleOptimizeController.paths = ['/test/path'];

      Object.defineProperty(window, 'location', {
        value: {
          pathname: '/test/path'
        }
      });
    });

    AnalyticsHelper.describeWithCookieSet(
      'google-optimize',
      GoogleOptimizeController,
      'optimize',
      'non-functional'
    );

    AnalyticsHelper.describeWhenEventFires(
      'google-optimize',
      GoogleOptimizeController,
      'optimize',
      'non-functional'
    );

    describe('initializing the pixel', () => {
      beforeEach(() => {
        AnalyticsHelper.setAcceptedCookie();
        AnalyticsHelper.initApp('google-optimize', GoogleOptimizeController, '1234');
      });

      it('appends the optimize script to the body', () => {
        const script = document.body.querySelector('script');
        expect(script.src).toEqual("https://www.googleoptimize.com/optimize.js?id=1234")
      });
    });
  });
});
