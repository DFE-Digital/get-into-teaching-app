import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['complete'];

  connect() {
    this.updateSubmit();
  }

  updateSubmit() {
    if (this.isLastStep()) {
      this.setSubmitText(this.data.get('complete'));
    } else {
      this.setSubmitText(this.data.get('continue'));
    }
  }

  isLastStep() {
    return this.radioInput.checked;
  }

  get radioInput() {
    return this.completeTarget.querySelector('input[type=radio]');
  }

  get submitButton() {
    return this.radioInput.form.querySelector('button[type=submit]');
  }

  setSubmitText(submitMsg) {
    this.submitButton.innerHTML = submitMsg;
    this.submitButton.dataset.disableWith = submitMsg;
  }
}
