import dayjs from 'dayjs';
import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['online', 'offline', 'unavailable', 'chat', 'container'];
  static values = {
    chatApiUrl: '/chat',
    chatWindowUrl: '/chat',
    refreshInterval: 61000,
  };

  initialize() {
    const utc = require('dayjs/plugin/utc');
    const timezone = require('dayjs/plugin/timezone');
    dayjs.extend(utc);
    dayjs.extend(timezone);
  }

  connect() {
    this.unavailableTarget.classList.add('hidden');
    // We set the initial state of the chat on the server side to reduce requests
    this.toggleState(this.isChatInitiallyAvailable());
    if (this.hasRefreshIntervalValue) {
      this.startRefreshing();
    }
  }

  disconnect() {
    this.stopRefreshing();
  }

  isChatInitiallyAvailable() {
    return this.containerTarget.dataset.available === 'true';
  }

  setChatState() {
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
      this.setChatState();
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
    this.loadChat();
  }

  loadChat() {
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
}
