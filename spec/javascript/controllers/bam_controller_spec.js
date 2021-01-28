import AnalyticsHelper from './analytics_spec_helper';
import BamController from 'bam_controller';

describe('BamController', () => {
  document.head.innerHTML = `<script></script>`;
  document.body.innerHTML = `
  <div
    id="container"
    data-controller="bam"
    data-bam-action="test"
    data-bam-event="test"
  >
  </div>
  `;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => {
    delete window.bam;
  });

  AnalyticsHelper.describeWithCookieSet(
    'bam',
    BamController,
    'bam',
    'non-functional'
  );
  AnalyticsHelper.describeWhenEventFires(
    'bam',
    BamController,
    'bam',
    'non-functional'
  );

  describe('tracking pixels', () => {
    beforeEach(() => {
      AnalyticsHelper.setAcceptedCookie();
      AnalyticsHelper.initApp('bam', BamController, 'bam');
    });

    it('appends each pixel to the controller element', () => {
      const container = document.getElementById('container');
      const images = Array.from(container.querySelectorAll('img'));
      const ids = BamController.ids;

      images.forEach((image) => {
        const match = ids.some((id) => image.src.indexOf(id) != -1);
        expect(match).toBeTruthy();
      });
    });
  });
});
