const Cookies = require('js-cookie') ;
import { Controller } from "stimulus"
import isTouchDevice from 'is-touch-device';

export default class extends Controller {
  static targets = ['dialog'];
  topExitSensitivity = 20;
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
    document.documentElement.addEventListener('mouseleave', this.handleMouseLeave);
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
    if (this.handleMouseLeave) {
      document.documentElement.removeEventListener('mouseleave', this.handleMouseLeave);
    }

    if (this.handleScroll) {
      window.removeEventListener('scroll', this.handleScroll);
    }
  }

  showDialog() {
    if (this.disabled) {
      return;
    }

    this.dialogTarget.style.display = 'flex';
    Cookies.set(this.cookieName, 'Disabled')
  }

  close(e) {
    e.preventDefault();
    this.dialogTarget.style.display = 'none';
  }

  disable() {
    Cookies.set(this.cookieName, 'Disabled', {expires: 365})
  }

  handleMouseLeave(e) {
    if (e.clientY <= this.topExitSensitivity) {
      this.showDialog();
    }
  }

  monitorScrollDistance(callback) {
    var isScrolling, start, end, distance;

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
  };

  get cookiesAccepted() {
    return Cookies.get('GiTBetaCookie') == 'Accepted' ;
  }

  get disabled() {
    return !this.cookiesAccepted || Cookies.get(this.cookieName) == 'Disabled';
  }

  get cookieName() {
    return 'GiTBetaFeedbackPrompt' ;
  }
}
