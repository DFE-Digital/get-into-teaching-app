import { ErrorSummary, Radios } from 'govuk-frontend';

// Find first error summary module to enhance.
var $errorSummary = document.querySelector(
  '[data-module="govuk-error-summary"]'
);
if ($errorSummary) {
  new ErrorSummary($errorSummary);
}

var $radios = [...document.querySelectorAll('[data-module="govuk-radios"]')];
$radios.forEach(($radio) => {
  new Radios($radio);
});
