import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['text', 'link']

  connect() {
    this.element.style.display = 'block';
  }

  yes(e) {
    e.preventDefault();
    this.submitAnswer('yes')
  }

  no(e) {
    e.preventDefault();
    this.submitAnswer('no')
  }

  async submitAnswer(answer) {
    this.disableLinks();
    
    fetch('/feedback/page_helpful', { 
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ 
        page_helpful: { 
          url: window.location.href.split('?')[0], 
          answer 
        }, 
        authenticity_token: await this.getToken() 
      })
    }) 
    .then(() => { 
      this.showThankYouText();
    })
    .catch(() => {
      this.showErrorText();
    })
    .finally(() => {
      this.hideLinks();
    });
  }

  async getToken() {
    const response = await fetch('/sessions/crsf_token');
    const json = await response.json();
    return json.token;
  }

  disableLinks() {
    this.linkTargets.forEach((target) => target.disabled = true);
  }

  showThankYouText() {
    this.textTarget.textContent = 'Thank you for your feedback';
  }

  showErrorText() {
    this.textTarget.textContent = 'Sorry, the response did not send successfully. \
    We really value your feedback, so please refresh the page or try again later';
  }

  hideLinks() {
    this.linkTargets.forEach((target) => target.style.display = 'none');
  }
}