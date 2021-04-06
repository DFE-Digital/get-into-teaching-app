import { initAll } from 'govuk-frontend';
import { enhanceSelectElement } from 'accessible-autocomplete';
import 'trix';

initAll();

document.body.className = document.body.className
  ? document.body.className + ' js-enabled'
  : 'js-enabled';

const selectId = '#internal-event-building-id-field';

enhanceSelectElement({
  selectElement: document.querySelector(selectId),
  placeholder: 'E.g., M1 7JA',
});
