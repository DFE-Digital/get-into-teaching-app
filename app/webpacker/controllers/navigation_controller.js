import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    console.debug("hi");
  }

  toggleWays(event) {
    const toggle = event.target.parentElement;
    const secondary = event.target.parentElement.querySelector('ol');

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
