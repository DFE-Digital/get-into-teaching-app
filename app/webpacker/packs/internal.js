import { initAll } from 'govuk-frontend';
import { enhanceSelectElement } from 'accessible-autocomplete';
import flatpickr from 'flatpickr';
import 'trix';
import '../styles/internal.scss';

initialiseGovUk();
initialiseSelectElement();
initialiseFlatpickr();

function initialiseGovUk() {
  initAll();

  // Needed for GovUK JavaScript
  document.body.className = document.body.className
    ? document.body.className + ' js-enabled'
    : 'js-enabled';
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

function initialiseFlatpickr() {
  const dateFormats = {
    // https://flatpickr.js.org/formatting/
    UK_FORMAT: 'd/m/Y H:i',
  };

  flatpickr('.flatpickr-enhanced-field', {
    enableTime: true,
    allowInput: true,
    altInput: true,
    altFormat: dateFormats.UK_FORMAT,
  });
}
