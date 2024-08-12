import dayjs from 'dayjs';
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['online', 'offline', 'unavailable', 'chat', 'container'];
  static values = {
    chatApiUrl: '/chat',
    chatWindowUrl: '/chat',
    refreshInterval: 20000,
  };

  initialize() {
    const utc = require('dayjs/plugin/utc');
    const timezone = require('dayjs/plugin/timezone');
    dayjs.extend(utc);
    dayjs.extend(timezone);
  }

  connect() {
    this.newChatEnabled = this.containerTarget.dataset.enabled === 'true';
    this.unavailableTarget.classList.add('hidden');

    if (this.newChatEnabled) {
      this.setNewChatState();
      if (this.hasRefreshIntervalValue) {
        this.startRefreshing();
      }
    } else {
      this.toggleState(this.isOldChatOnline());
    }
  }

  disconnect() {
    this.stopRefreshing();
  }

  isOldChatOnline() {
    const timeZone = 'Europe/London';
    const openTime = dayjs().set('hour', 8).set('minute', 30).tz(timeZone);
    const closeTime = dayjs().set('hour', 17).set('minute', 30).tz(timeZone);
    const now = dayjs().tz(timeZone);
    const weekend = [6, 0].includes(now.get('day'));

    return !weekend && now >= openTime && now <= closeTime;
  }

  setNewChatState() {
    fetch(this.chatApiUrlValue, { headers: { Accept: 'application/json' } })
      .then(
        (response) => response.json(),
        (result) => this.stopRefreshing(),
      )
      .then((data) => {
        if (data) {
          this.toggleState(data.available);
        }
      });
  }

  toggleState(online) {
    if (online) {
      // enable chat button
      if (this.onlineTarget.classList.contains('hidden')) {
        this.onlineTarget.classList.remove('hidden');
      }
      if (!this.offlineTarget.classList.contains('hidden')) {
        this.offlineTarget.classList.add('hidden');
      }
    } else {
      // disable chat button
      if (!this.onlineTarget.classList.contains('hidden')) {
        this.onlineTarget.classList.add('hidden');
      }
      if (this.offlineTarget.classList.contains('hidden')) {
        this.offlineTarget.classList.remove('hidden');
      }
    }
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.setNewChatState();
    }, this.refreshIntervalValue);
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer);
    }
  }

  start(e) {
    this.previousTarget = e.target;
    e.preventDefault();

    if (this.newChatEnabled) {
      this.loadNewChat();
    } else {
      this.loadOldChat();
    }
  }

  loadNewChat() {
    const windowFeatures = 'left=100,top=100,width=400,height=600';
    const handle = window.open(
      this.chatWindowUrlValue,
      'chatWindow',
      windowFeatures,
    );
    if (!handle) {
      alert('Please enable pop-ups to open the chat window');
    }
  }

  loadOldChat() {
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
      'https://static.zdassets.com/ekr/snippet.js?key=34a8599c-cfec-4014-99bd-404a91839e37';
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
    }, 100);
  }

  showWebWidget() {
    window.zE('messenger', 'open');
  }

  get zendeskScriptLoaded() {
    return document.querySelector('#ze-snippet') !== null;
  }
}
