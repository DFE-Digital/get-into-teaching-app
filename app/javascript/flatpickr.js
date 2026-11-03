import flatpickr from 'flatpickr';

document.addEventListener('turbolinks:load', initFlatpicker);

function initFlatpicker() {
  const dateFormats = {
    // https://flatpickr.js.org/formatting/
    UK_DATE_TIME_FORMAT: 'd/m/Y H:i',
    UK_DATE_FORMAT: 'd/m/Y',
  };

  flatpickr('.flatpickr-enhanced-field', {
    enableTime: true,
    allowInput: true,
    altInput: true,
    altFormat: dateFormats.UK_DATE_TIME_FORMAT,
  });

  flatpickr('.flatpickr-enhanced-date-field', {
    enableTime: false,
    allowInput: true,
    altInput: true,
    altFormat: dateFormats.UK_DATE_FORMAT,
  });
}
