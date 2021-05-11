import isTouchDevice from 'is-touch-device';
import { Controller } from 'stimulus';
const mailingListDismissedKey = 'mailingListDismissed';

export default class extends Controller {
  static targets = ['dialog'];
  topExitSensitivity = 0;
  topScrollEndSensitivity = 300;
  topScrollMinimumDistance = 700;

  connect() {
    if (isTouchDevice()) {
      this.setupTouchDevice();
    } else {
      this.setupDesktop();
    }
  }

  setupDesktop() {
    this.handleMouseLeave = this.handleMouseLeave.bind(this);
    document.documentElement.addEventListener(
      'mouseleave',
      this.handleMouseLeave
    );
  }

  setupTouchDevice() {
    this.monitorScrollDistance((distance, _start, end) => {
      const scrollUp = distance < 0;
      const atTop = end < this.topScrollEndSensitivity;
      const longScroll = Math.abs(distance) >= this.topScrollMinimumDistance;

      if (!scrollUp || !atTop || !longScroll) {
        return;
      }

      this.showDialog();
    });
  }

  disconnect() {
    clearTimeout(this.delayTimeout);

    if (this.handleMouseLeave) {
      document.documentElement.removeEventListener(
        'mouseleave',
        this.handleMouseLeave
      );
    }

    if (this.handleScroll) {
      window.removeEventListener('scroll', this.handleScroll);
    }
  }

  showDialog() {
    if (this.mailingListDismissed) {
      return;
    }

    this.dialogTarget.style.display = 'flex';
  }

  accept() {
    // hook in any logging to a successful response here
    this.dismissMailingListPopup();
  }

  dismiss(event) {
    if (event) event.preventDefault();

    this.dismissMailingListPopup();
    this.hide()
  }

  hide() {
    this.dialogTarget.style.display = 'none';
  }

  dismissMailingListPopup() {
    return window.localStorage.setItem(mailingListDismissedKey, 'true');
  }

  handleMouseLeave(e) {
    if (e.clientY <= this.topExitSensitivity) {
      this.showDialog();
    }
  }

  monitorScrollDistance(callback) {
    let isScrolling, start, end, distance;

    const onScroll = () => {
      if (!start) {
        start = window.pageYOffset;
      }

      window.clearTimeout(isScrolling);

      isScrolling = setTimeout(() => {
        end = window.pageYOffset;
        distance = end - start;

        callback(distance, start, end);

        start = end = distance = null;
      }, 50);
    };

    this.handleScroll = onScroll.bind(this);
    window.addEventListener('scroll', this.handleScroll, false);
  }

  get mailingListDismissed() {
    return window.localStorage.getItem(mailingListDismissedKey) === 'true';
  }
}
