import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    fieldId: String,
    errorId: String,
  };

  connect() {
    const autocomplete = document.getElementById(this.fieldIdValue);

    if (autocomplete) {
      const currentDescribedBy =
        autocomplete.getAttribute('aria-describedby') || '';

      autocomplete.setAttribute(
        'aria-describedby',
        `${this.errorIdValue} ${currentDescribedBy}`.trim(),
      );
    }
  }
}
