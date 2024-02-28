import Clarity from '../javascript/clarity';

const clarityId = document.querySelector('[data-clarity-id]').dataset.clarityId;

if (clarityId) {
  const clarity = new Clarity(clarityId);
  clarity.init();
}
