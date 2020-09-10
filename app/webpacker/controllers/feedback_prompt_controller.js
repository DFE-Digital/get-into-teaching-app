import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['dialog'];
  sensitivity = 20;

  connect() {
    this.handleMouseLeave = this.showDialog.bind(this);
    document.documentElement.addEventListener('mouseleave', this.handleMouseLeave);
  }

  disconnect() {
    document.documentElement.removeEventListener('mouseleave', this.handleMouseLeave);
  }

  showDialog(e) {
    if (this.disabled || e.clientY > this.sensitivity) {
      return;
    }

    this.dialogTarget.style.display = 'flex';
    document.cookie = this.cookie;
  }

  close(e) {
    e.preventDefault();
    this.dialogTarget.style.display = 'none';
  }

  disable() {
    var expiry = new Date();
    expiry.setFullYear(expiry.getFullYear() + 1);
    document.cookie = `${this.cookie}; expires=${expiry.toUTCString()}`
  }

  get cookiesAccepted() {
    return document.cookie.indexOf('GiTBetaCookie=Accepted') > -1;
  }

  get disabled() {
    return !this.cookiesAccepted || document.cookie.indexOf(this.cookie) != -1;
  }

  get cookie() {
    return 'GiTBetaFeedbackPrompt=Disabled';
  }
}