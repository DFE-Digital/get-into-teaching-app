import Gtm from '../javascript/gtm';

const gtmId = document.querySelector('[data-gtm-id]').dataset.gtmId;

if (gtmId) {
  const gtm = new Gtm(gtmId);
  gtm.init();
}
