import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['results'];

  connect() {}

  selectRightAnswer(_event) {
    this.resultsTarget.classList.remove('incorrect');
    this.resultsTarget.classList.add('correct');
  }

  selectWrongAnswer(_event) {
    this.resultsTarget.classList.remove('correct');
    this.resultsTarget.classList.add('incorrect');
  }
}
