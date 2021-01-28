import AnalyticsHelper from './analytics_spec_helper';
import LidController from 'lid_controller';

describe('LidController', () => {
  const event = 'testEvent';

  document.body.innerHTML = `
    <div
      id="container"
      data-controller="lid"
      data-lid-action="track"
      data-lid-event="${event}"
    >
    </div>
    `;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => {
    delete window.lid;
  });

  AnalyticsHelper.describeWithCookieSet(
    'lid',
    LidController,
    'lid',
    'non-functional'
  );
  AnalyticsHelper.describeWhenEventFires(
    'lid',
    LidController,
    'lid',
    'non-functional'
  );

  describe('tracking pixels', () => {
    beforeEach(() => {
      AnalyticsHelper.setAcceptedCookie();
      AnalyticsHelper.initApp('lid', LidController, 'lid');
    });

    it('loads images from the correct domains', () => {
      expect(LidController.domains).toEqual([
        'https://pixelg.adswizz.com',
        'https://tracking.audio.thisisdax.com',
      ]);
    });

    it('appends pixels using the correct path/event name', () => {
      const container = document.getElementById('container');
      const images = Array.from(container.querySelectorAll('img'));
      const match = images.every(
        (image) =>
          image.src.indexOf(
            `/one.png&?client=GovernmentDFE&action=cs&j=0&event=${event}`
          ) !== -1
      );
      expect(match).toBeTruthy();
    });

    it('appends a pixel for each domain to the controller element', () => {
      const container = document.getElementById('container');
      const images = Array.from(container.querySelectorAll('img'));
      const domains = LidController.domains;

      domains.forEach((domain) => {
        const match = images.some((image) => image.src.indexOf(domain) !== -1);
        expect(match).toBeTruthy();
      });
    });
  });
});
