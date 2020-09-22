const Cookies = require('js-cookie');
import AnalyticsHelper from './analytics_spec_helper';
import BamController from 'bam_controller';

describe('BamController', () => {
  document.head.innerHTML = `<script></script>`;
  document.body.innerHTML = `
  <div
    data-controller="bam"
    data-bam-action="test"
    data-bam-event="test"
  >
  </div>
  `;

  // window appears to not be getting redefined between runs, so remove manually
  afterEach(() => { delete window.bam })

  AnalyticsHelper.describeWithCookieSet('bam', BamController, 'bam', 'non-functional')
  AnalyticsHelper.describeWhenEventFires('bam', BamController, 'bam', 'non-functional')

  describe("tracking pixels", () => {
    beforeEach(() => { 
      AnalyticsHelper.setAcceptedCookie();
      AnalyticsHelper.initApp('bam', BamController, 'bam');
      window.fetch.resetMocks();
    })

    it("makes a fetch request for each pixel", () => {
      const urls = fetch.mock.calls.map((call) => call[0]);

      expect(urls).toEqual([
        'https://linkbam.uk/m/3g6cKlN4VmA4FAL/1SlB2.png',
        'https://linkbam.uk/m/nis3acYUOeaVpuG/RPOzc.png',
        'https://linkbam.uk/m/cfZRDrq9SRKrBVU/FpASD.png',
        'https://linkbam.uk/m/V8R6qhowRkziLjG/Eg0N9.png',
        'https://linkbam.uk/m/X4KBgSPXbMgXXon/CRJA9.png',
        'https://linkbam.uk/m/MP8YKC867PjN6Rl/BTYf2.png',
        'https://linkbam.uk/m/5DRPPG8Sakm5o8i/4yVXp.png',
        'https://linkbam.uk/m/fSSR83JdeURiiQ3/YNZ99.png',
        'https://linkbam.uk/m/nwQx6WBpT23FfAn/1hnVZ.png',
        'https://linkbam.uk/m/3BSBg0IMtWQmpkb/wFCtJ.png',
        'https://linkbam.uk/m/1MbhNg55GhAVDkd/3VrFR.png',
        'https://linkbam.uk/m/Ae4BnnTfkvZ5pRz/dbgOi.png',
      ])
    })
  })
})
