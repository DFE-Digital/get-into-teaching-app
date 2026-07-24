import { initAll } from 'govuk-frontend';
import { enhanceSelectElement } from 'accessible-autocomplete';
import 'trix';
import '../styles/internal.scss';

initialiseGovUk();
initialiseSelectElement();

function initialiseGovUk() {
  initAll();
}

function initialiseSelectElement() {
  const selectId = document.querySelector('#internal-event-building-id-field');

  if (selectId) {
    enhanceSelectElement({
      selectElement: selectId,
      placeholder: 'E.g., M1 7JA',
    });
  }
}
