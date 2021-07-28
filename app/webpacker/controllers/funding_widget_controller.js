import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['form'];

  submitForm(e) {
    this.formTarget.submit();
  }
}
