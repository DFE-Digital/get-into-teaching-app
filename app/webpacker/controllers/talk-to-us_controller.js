import dayjs from 'dayjs';
import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['button', 'offlineText'];

  initialize() {
    const utc = require('dayjs/plugin/utc');
    const timezone = require('dayjs/plugin/timezone');
    dayjs.extend(utc);
    dayjs.extend(timezone);
  }

  connect() {
    if (!this.isChatAvailable()) {
      this.chatOffline();
    }
  }

  isChatAvailable() {
    const timeZone = 'Europe/London';
    const openTime = dayjs().set('hour', 8).set('minute', 30).tz(timeZone);
    const closeTime = dayjs().set('hour', 17).set('minute', 30).tz(timeZone);
    const now = dayjs().tz(timeZone);

    return now >= openTime && now <= closeTime;
  }

  chatOffline() {
    if (this.hasOfflineTextTarget) {
      this.offlineTextTarget.classList.add('visible');
    }

    this.buttonTarget.classList.add('hidden');
  }

  startChat(e) {
    e.preventDefault();
    this.showZendeskChat();
  }

  showZendeskChat() {
    const originalText = this.setLoadingButtonText();
    this.appendZendeskScript();
    this.waitForZendesk(() => {
      window.$zopim.livechat.window.show();
      this.waitForWidget(() => {
        setTimeout(() => {
          document.getElementById('webWidget').focus();
          this.buttonTarget.querySelector('span').innerHTML = originalText;
        }, 500); // Small delay to account for the chat box animating in.
      });
    });
  }

  setLoadingButtonText() {
    const originalText = this.buttonTarget.querySelector('span').textContent;

    if (!this.zendeskScriptLoaded) {
      this.buttonTarget.querySelector('span').textContent = 'Starting chat...';
    }

    return originalText;
  }

  appendZendeskScript() {
    if (this.zendeskScriptLoaded) {
      return;
    }

    const script = document.createElement('script');
    script.setAttribute('id', 'ze-snippet');
    script.src =
      'https://static.zdassets.com/ekr/snippet.js?key=34a8599c-cfec-4014-99bd-404a91839e37';
    document.body.appendChild(script);
  }

  waitForWidget(callback) {
    const interval = setInterval(() => {
      if (document.getElementById('webWidget')) {
        clearInterval(interval);
        callback();
      }
    }, 100);
  }

  waitForZendesk(callback) {
    const interval = setInterval(() => {
      if (window.$zopim && window.$zopim.livechat) {
        clearInterval(interval);
        callback();
      }
    }, 100);
  }

  get zendeskScriptLoaded() {
    return document.querySelector('#ze-snippet') !== null;
  }
}
