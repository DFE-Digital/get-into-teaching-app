import { Controller } from "stimulus";

export default class extends Controller {
  static get targets() {
    return ["button"];
  }

  handleClick() {
    if (this.disableWith) {
      this.buttonTarget.disabled = true;
      this.buttonTarget.textContent = this.disableWith;
    }
  }

  get disableWith() {
    return this.data.get("disable-with");
  }
}
