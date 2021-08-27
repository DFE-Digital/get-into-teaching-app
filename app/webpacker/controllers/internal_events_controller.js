import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['name', 'startAt', 'partialUrl', 'errorMessage'];

  populatePartialUrl() {
    const nameValue = this.nameTarget.value;
    const startAtValue = this.startAtTarget.value;

    if (nameValue === '' || startAtValue === '') {
      this.toggleErrorMessageVisibility(true);
      this.partialUrlTarget.value = '';
    } else {
      this.toggleErrorMessageVisibility(false);
      this.partialUrlTarget.value = this.generatePartialUrl(
        startAtValue,
        nameValue
      );
    }
  }

  generatePartialUrl(startAtValue, nameValue) {
    const date = this.formatDate(startAtValue);
    const name = this.formatName(nameValue);

    return `${date}-${name}`;
  }

  toggleErrorMessageVisibility(visible) {
    this.errorMessageTarget.style.display = visible ? 'block' : 'none';
  }

  formatDate(dateTimeString) {
    const date = new Date(dateTimeString);
    const year = date.getFullYear().toString().slice(-2);
    const month = `0${date.getMonth() + 1}`.slice(-2);
    const day = `0${date.getDate()}`.slice(-2);

    return `${year}${month}${day}`;
  }

  formatName(name) {
    return name.trim().toLowerCase().replace(/-/g, '').split(/\s+/).join('-');
  }
}
