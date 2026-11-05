import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['source', 'showhide'];

  connect() {
    this.toggle();
  }

  match(sourceValue) {
    if (this.mode === 'hide') return sourceValue !== this.expected;
    else return sourceValue === this.expected;
  }

  toggle() {
    if (this.match(this.sourceValue)) {
      this.showField();
    } else {
      this.hideField();
    }
  }

  get mode() {
    return this.data.get('mode');
  }

  get expected() {
    return this.data.get('expected');
  }

  get sourceValue() {
    return this.sourceTarget.value.trim();
  }

  get fieldInputs() {
    return Array.from(this.showhideTarget.querySelectorAll('input,select'));
  }

  hideField() {
    for (const input of this.fieldInputs) input.disabled = true;

    this.showhideTarget.classList.add('hidden');
  }

  showField() {
    for (const input of this.fieldInputs) input.disabled = false;

    this.showhideTarget.classList.remove('hidden');
  }
}
