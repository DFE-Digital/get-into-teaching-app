import { initAll } from 'govuk-frontend';
import { enhanceSelectElement } from 'accessible-autocomplete';

document.addEventListener('turbolinks:load', initAll);
document.addEventListener('turbolinks:load', initialiseSelectElement);

function initialiseSelectElement() {
  document
    .querySelectorAll('.select-accessible-autocomplete')
    .forEach((select) => {
      enhanceSelectElement({
        selectElement: select,
        placeholder: 'E.g., M1 7JA',
      });
    });
}
