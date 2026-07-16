import flatpickr from 'flatpickr';

(function () {
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
})();
