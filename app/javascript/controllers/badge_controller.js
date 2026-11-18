import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { path: String, jsonKey: String };

  connect() {
    if (this.supported) {
      this.restoreCountFromCache();
      this.requestCount();
    }
  }

  handleCount(count) {
    if (isNaN(count) || count < 1) {
      return;
    }

    this.cachedCount = count;
    this.showBadge(count);
  }

  showBadge(count) {
    const span = document.createElement('span');
    span.innerText = count;

    // We need to replace any existing span that
    // Turbolinks has retained as part of its cache.
    this.element.innerHTML = '';
    this.element.appendChild(span);
  }

  restoreCountFromCache() {
    if (this.cachedCount) {
      this.showBadge(this.cachedCount);
    }
  }

  requestCount() {
    const options = {
      headers: {
        Accept: 'application/json',
      },
    };

    fetch(this.pathValue, options)
      .then((response) => response.json())
      .then((json) => {
        if (this.jsonKeyValue in json) {
          this.handleCount(json[this.jsonKeyValue]);
        }
      })
      .catch(() => {}); // Ignore (error will log on server-side).
  }

  get cachedCount() {
    return this.badgeCache[this.badgeKey];
  }

  set cachedCount(count) {
    this.badgeCache[this.badgeKey] = count;
  }

  get badgeCache() {
    return (window.badgeCache ||= {});
  }

  get badgeKey() {
    return `${this.pathValue}-${this.jsonKeyValue}`;
  }

  get supported() {
    return 'fetch' in window;
  }
}
