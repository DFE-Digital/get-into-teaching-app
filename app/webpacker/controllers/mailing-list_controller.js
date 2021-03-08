import { Controller } from 'stimulus';

const countKey = 'mailingListPageCount';
const mailingListDismissedKey = 'mailingListDismissed';

export default class extends Controller {
  connect() {
    if (!this.mailingListDismissed) {
      this.incrementMailingListPageCounter();

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
    this.dismissMailingList();
    this.hide();
  }

  // we'll probably want to record the fact that
  // someone's followed the mailing list link
  beginMailingListJourney() {
    this.dismiss();
  }

  incrementMailingListPageCounter() {
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

  dismissMailingList() {
    return window.localStorage.setItem(mailingListDismissedKey, 'true');
  }

  get mailingListDismissed() {
    return window.localStorage.getItem(mailingListDismissedKey) === 'true';
  }
}
