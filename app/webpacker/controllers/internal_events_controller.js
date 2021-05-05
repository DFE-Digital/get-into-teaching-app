import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['name', 'startAt', 'partialUrl'];

  get nameValue() {
    return this.nameTarget.value;
  }

  get startAtValue() {
    return this.startAtTarget.value;
  }

  get partialUrlValue() {
    return this.partialUrlTarget.value;
  }

  set partialUrlValue(value) {
    this.partialUrlTarget.value = value;
  }

  generateButtonClicked(event) {
    event.preventDefault();

    const date = this.formatDate(this.startAtValue);
    const name = this.formatName(this.nameValue);
    this.partialUrlValue = this.generatePartialUrl(date, name);
  }

  generatePartialUrl(date, name) {
    if (date === '' || name === '') return '';

    return `${date}-${name}`;
  }

  formatDate(dateTimeString) {
    if (dateTimeString === '') return '';

    const date = dateTimeString.substring(0, dateTimeString.indexOf('T'));
    const [year, month, day] = date.split('-');
    return year.slice(-2) + month + day;
  }

  formatName(name) {
    return name.trim().toLowerCase().split(/\s+/).join('-');
  }
}
