import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['name', 'startAt', 'partialUrl', 'errorMessage'];

  populatePartialUrl() {
    const nameValue = this.nameTarget.value;
    const startAtValue = this.startAtTarget.value;

    if (nameValue === '' || startAtValue === '') {
      this.partialUrlTarget.value = '';
      this.toggleErrorMessageVisibility(true);
      return;
    }

    this.toggleErrorMessageVisibility(false);
    const date = this.formatDate(startAtValue);
    const name = this.formatName(nameValue);
    this.partialUrlTarget.value = this.generatePartialUrl(date, name);
  }

  generatePartialUrl(date, name) {
    return `${date}-${name}`;
  }

  toggleErrorMessageVisibility(visible) {
    this.errorMessageTarget.style.display = visible ? 'block' : 'none';
  }

  formatDate(dateTimeString) {
    const date = dateTimeString.substring(0, dateTimeString.indexOf('T'));
    const [year, month, day] = date.split('-');
    return year.slice(-2) + month + day;
  }

  formatName(name) {
    return name.trim().toLowerCase().split(/\s+/).join('-');
  }
}
