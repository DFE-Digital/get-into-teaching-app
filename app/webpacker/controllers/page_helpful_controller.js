import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['text', 'link']

  connect() {
    this.element.style.display = 'block';
  }

  answer() {
    // Answer is captured by event configured in GTM.
    this.hideLinks();
    this.showThankYouText();
  }

  showThankYouText() {
    this.textTarget.textContent = 'Thank you for your feedback';
  }

  hideLinks() {
    this.linkTargets.forEach((target) => target.style.display = 'none');
  }
}