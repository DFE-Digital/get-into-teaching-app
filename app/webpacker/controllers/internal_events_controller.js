import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['name', 'startAt', 'partialUrl'];

  populatePartialUrl() {
    const date = this.formatDate(this.startAtTarget.value);
    const name = this.formatName(this.nameTarget.value);
    this.partialUrlTarget.value = this.generatePartialUrl(date, name);
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
