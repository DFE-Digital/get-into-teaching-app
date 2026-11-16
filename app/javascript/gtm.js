import Gtm from './lib/gtm';

const gtmId = document.querySelector('[data-gtm-id]')?.dataset.gtmId;

if (gtmId) {
  const gtm = new Gtm(gtmId);
  gtm.init();
}
