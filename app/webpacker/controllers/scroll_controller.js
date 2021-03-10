import { Controller } from 'stimulus';

export default class extends Controller {
  static previousTopKey = 'scroll-previousTop';

  connect() {
    this.restore();
  }

  restore() {
    if (this.previousTop) {
      window.scrollTo(0, this.previousTop);
      this.clearPreviousTop();
    }
  }

  preserve() {
    this.previousTop = document.documentElement.scrollTop;
  }

  clearPreviousTop() {
    window.localStorage.removeItem(this.constructor.previousTopKey);
  }

  set previousTop(value) {
    window.localStorage.setItem(this.constructor.previousTopKey, value);
  }

  get previousTop() {
    return window.localStorage.getItem(this.constructor.previousTopKey);
  }
}
