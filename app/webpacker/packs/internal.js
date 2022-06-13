import { enhanceSelectElement } from 'accessible-autocomplete';
import flatpickr from 'flatpickr';
import 'trix';
import '../styles/internal.scss';

initialiseSelectElement();
initialiseFlatpickr();

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
