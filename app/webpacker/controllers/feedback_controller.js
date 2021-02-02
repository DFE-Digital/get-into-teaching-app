import { Controller } from 'stimulus';

const countKey = 'feedbackPageCount';
const feedbackDismissedKey = 'feedbackDismissed';

export default class extends Controller {
  connect() {
    if (!this.feedbackDismissed) {
      this.incrementFeedbackPageCounter();

      if (this.pageViewCount >= 3) {
        this.show();
      }
    }
  }

  show() {
    this.element.style.display = 'flex';
  }

  hide() {
    this.element.style.display = 'none';
  }

  dismiss(event) {
    if (event) event.preventDefault();
    this.dismissFeedback();
    this.hide();
  }

  // we'll probably want to record the fact that
  // someone's followed the feedback link
  giveFeedback() {
    this.dismiss();
  }

  incrementFeedbackPageCounter() {
    const currentValue = this.pageViewCount;

    this.updatePageViewCount(currentValue + 1);
  }

  updatePageViewCount(value) {
    return window.localStorage.setItem(countKey, value);
  }

  get pageViewCount() {
    const count = window.localStorage.getItem(countKey) || 0;

    return parseInt(count);
  }

  dismissFeedback() {
    return window.localStorage.setItem(feedbackDismissedKey, 'true');
  }

  get feedbackDismissed() {
    return window.localStorage.getItem(feedbackDismissedKey) === 'true';
  }
}
