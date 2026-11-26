import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['form'];

  submitForm(e) {
    this.formTarget.submit();
  }
}
