import { ErrorSummary } from 'govuk-frontend'

// Find first error summary module to enhance.
var $errorSummary = document.querySelector('[data-module="govuk-error-summary"]');
new ErrorSummary($errorSummary).init();
