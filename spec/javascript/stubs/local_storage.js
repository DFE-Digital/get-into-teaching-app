export default class StubLocalStorage {
  constructor(store = {}) {
    this.store = store;
  }

  getItem(key) {
    return this.store[key];
  }

  setItem(key, value) {
    return (this.store[key] = value);
  }
}
