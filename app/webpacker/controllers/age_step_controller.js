import { Controller } from 'stimulus';

export default class extends Controller {
  static values = { displayOption: String };

  connect() {
    this.sendPageView();
  }

  get googleAnalyticsId() {
    const gaId = document.body.getAttribute('data-analytics-ga-id');

    if (gaId && gaId.trim() !== '') {
      return gaId;
    }
  }

  sendPageView() {
    if (window.ga && this.googleAnalyticsId) {
      window.ga('send', {
        hitType: 'pageview',
        page: `${window.location.pathname}/${this.displayOptionValue}`,
        title: `Get personalised to your inbox, age step (${this.displayOptionValue}) | Get Into Teaching`,
      });
    }
  }
}
