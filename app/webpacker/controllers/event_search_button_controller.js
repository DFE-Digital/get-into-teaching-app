import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['updateResultsButton'];

  connect() {
    this.setButtonStyle('disabled');
  }

  parameterChanged() {
    this.setButtonStyle('enabled');
  }

  setButtonStyle(style) {
    if (style === 'disabled') {
      this.updateResultsButtonTarget.classList.add('disabled-button');
      this.updateResultsButtonTarget.classList.remove('request-button');
    } else if (style === 'enabled') {
      this.updateResultsButtonTarget.classList.remove('disabled-button');
      this.updateResultsButtonTarget.classList.add('request-button');
    }
  }
}
