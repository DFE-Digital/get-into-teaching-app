import { initAll } from 'govuk-frontend';
import { enhanceSelectElement } from 'accessible-autocomplete';
import 'trix';
import '../styles/internal.scss';

initAll();

// Needed for GovUK JavaScript
document.body.className = document.body.className
  ? document.body.className + ' js-enabled'
  : 'js-enabled';

const selectId = document.querySelector('#internal-event-building-id-field');

if (selectId) {
  enhanceSelectElement({
    selectElement: selectId,
    placeholder: 'E.g., M1 7JA',
  });
}
