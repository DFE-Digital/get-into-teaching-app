const countKey = 'feedbackPageCount';
const feedbackDismissedKey = 'feedbackDismissed';

import { Controller } from "stimulus" ;

export default class extends Controller {
  connect() {
    this.incrementFeedbackPageCounter();

    // if the user has viewed more than two pages and
    // hasn't yet dismissed the feedback banner, keep
    // showing it until they do
    if (this.feedbackDismissed || this.pageViewCount <= 2) {
      this.hideBanner();
    }
  }

  hideBanner() {
    this.element.style.display = 'none';
  }

  dismiss() {
    this.dismissFeedback();
    this.hideBanner();
  }

  // we'll probably want to record the fact that
  // someone's followed the feedback link
  giveFeedback() {
    this.dismiss();
  }

  incrementFeedbackPageCounter() {
    const currentValue = this.pageViewCount;

    if (currentValue) {
      this.updatePageViewCount(currentValue + 1)
    }
    else {
      // initialise the counter
      this.updatePageViewCount(1)
    }
  }

  updatePageViewCount(value) {
    return window.localStorage.setItem(countKey, value);
  }

  get pageViewCount() {
    let count = window.localStorage.getItem(countKey);

    if (count) {
      return parseInt(count);
    }

    return null;
  }

  dismissFeedback() {
    return window.localStorage.setItem(feedbackDismissedKey, "true");
  }

  get feedbackDismissed() {
    return "true" === window.localStorage.getItem(feedbackDismissedKey);
  }
}
