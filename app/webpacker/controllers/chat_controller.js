import dayjs from 'dayjs';
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['online', 'offline', 'unavailable', 'chat'];

  initialize() {
    const utc = require('dayjs/plugin/utc');
    const timezone = require('dayjs/plugin/timezone');
    dayjs.extend(utc);
    dayjs.extend(timezone);
  }

  connect() {
    this.unavailableTarget.classList.add('hidden');

    if (this.isChatOnline()) {
      this.onlineTarget.classList.remove('hidden');
    } else {
      this.offlineTarget.classList.remove('hidden');
    }
  }

  isChatOnline() {
    const timeZone = 'Europe/London';
    const openTime = dayjs().set('hour', 8).set('minute', 30).tz(timeZone);
    const closeTime = dayjs().set('hour', 17).set('minute', 30).tz(timeZone);
    const now = dayjs().tz(timeZone);
    const weekend = [6, 0].includes(now.get('day'));

    return !weekend && now >= openTime && now <= closeTime;
  }

  start(e) {
    this.previousTarget = e.target;
    e.preventDefault();
    this.loadChat();
  }

  loadChat() {
    if (!this.zendeskScriptLoaded) {
      this.chatTarget.textContent = 'Starting chat...';
    }

    this.appendZendeskScript();

    this.waitForZendeskScript(() => {
      this.showWebWidget();
      this.waitForWebWidget(() => {
        this.chatTarget.textContent = 'Chat online';
      });
    });
  }

  appendZendeskScript() {
    if (this.zendeskScriptLoaded) {
      return;
    }

    const script = document.createElement('script');
    script.setAttribute('id', 'ze-snippet');
    script.src =
      'https://static.zdassets.com/ekr/snippet.js?key=32605345-0b23-4904-9dc1-db94653c370b';
    document.body.appendChild(script);
  }

  waitForWebWidget(callback) {
    const interval = setInterval(() => {
      if (window.zEACLoaded) {
        clearInterval(interval);
        // Small delay to account for the chat box animating in.
        setTimeout(() => {
          callback();
        }, 500);
      }
    }, 100);
  }

  waitForZendeskScript(callback) {
    const interval = setInterval(() => {
      if (window.zEACLoaded) {
        clearInterval(interval);
        callback();
      }
    }, 1000);
  }

  showWebWidget() {
    zE('messenger', 'open');
  }

  get zendeskScriptLoaded() {
    return document.querySelector('#ze-snippet') !== null;
  }
}
