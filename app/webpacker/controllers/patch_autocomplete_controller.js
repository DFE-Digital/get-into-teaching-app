import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { inputBaseId: String };

  get hint() {
    return document.getElementById(`${this.inputBaseIdValue}-hint`);
  }

  get autocomplete() {
    return document.querySelector(
      `input#${this.inputBaseIdValue}-field, input#${this.inputBaseIdValue}-field-error`,
    );
  }

  get errorMsg() {
    return document.getElementById(`${this.inputBaseIdValue}-error`);
  }

  get popup() {
    return document.querySelector(
      `ul#${this.inputBaseIdValue}-field__listbox, ul#${this.inputBaseIdValue}-field-error__listbox`,
    );
  }

  connect() {
    if (this.hint) {
      this.waitForAutocomplete();
    }
  }

  waitForAutocomplete() {
    if (this.autocomplete) {
      // if there is an error message, connect it to the autocomplete input
      if (this.errorMsg) {
        const currentDescribedBy =
          this.autocomplete.getAttribute('aria-describedby') || '';

        this.autocomplete.setAttribute(
          'aria-describedby',
          `${this.errorMsg.id} ${currentDescribedBy}`.trim(),
        );
      }

      // if there is a pop-up, connect it to the autocomplete
      if (this.popup) {
        this.autocomplete.setAttribute('aria-controls', `${this.popup.id}`);
      }
      return;
    }

    requestAnimationFrame(() => this.waitForAutocomplete());
  }
}
