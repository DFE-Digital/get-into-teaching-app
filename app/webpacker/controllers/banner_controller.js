import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.hideOnLoad();
  }

  hideOnLoad() {
    if(document.cookie.indexOf(this.cookie) != -1) {
      this.hideBanner();
    }
  }

  hide(e) {
    e.preventDefault();
    this.hideBanner();
    this.setCookie();
  }

  hideBanner() {
    this.element.style.display = 'none';
  }

  setCookie() {
    document.cookie = this.cookie;
  }

  get cookie() {
    return `GiTBetaBanner${this.name}=Hidden`;
  }

  get name() {
    return this.data.get('name');
  }
}