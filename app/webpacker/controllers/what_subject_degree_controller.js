import { Controller } from '@hotwired/stimulus';
export default class extends Controller {
  static targets = [
    'noJSContainer',
    'noJSDegreeSubject',
    'noJSEnabled',
    'degreeSubjectAutoComplete',
    'degreeSubjectSelect',
  ];

  connect() {
    this.noJSEnabledTarget.value = 'false';
    this.noJSContainerTarget.style.display = 'none';
    this.degreeSubjectSelectTarget.disabled = false;
    this.degreeSubjectAutoCompleteTarget.style.display = 'block';
  }
}
