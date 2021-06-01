import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['secondary', 'toggle'];

  connect() {
    console.debug("hi");
  }

  toggleWays(e) {
    console.debug(e)

    const toggle = this.toggleTarget;
    const secondary = this.secondaryTarget;

    if (secondary.classList.contains("hidden")) {
      console.debug("hiding secondary...");
      secondary.classList.remove("hidden");

      toggle.classList.remove("down");
      toggle.classList.add("up");
    } else {
      console.debug("showing secondary...");
      secondary.classList.add("hidden");

      toggle.classList.remove("up");
      toggle.classList.add("down");
    }
  }
}
