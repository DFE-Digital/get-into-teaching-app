import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    fieldId: String,
    errorId: String,
  };

  connect() {
    if (document.getElementById(this.errorIdValue)) {
      this.waitForAutocomplete();
    }
  }

  waitForAutocomplete() {
    const autocomplete = document.querySelector(
      `input[id="${this.fieldIdValue}"]`,
    );

    if (autocomplete) {
      const currentDescribedBy =
        autocomplete.getAttribute('aria-describedby') || '';

      autocomplete.setAttribute(
        'aria-describedby',
        `${this.errorIdValue} ${currentDescribedBy}`.trim(),
      );

      return;
    }

    requestAnimationFrame(() => this.waitForAutocomplete());
  }
}
