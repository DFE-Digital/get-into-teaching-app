import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['secondary'];

  connect() {
    console.debug("hi");
  }

  toggleWays(e) {
    console.debug(e)

    let secondary = this.secondaryTarget;

    if (secondary.classList.contains("hidden")) {
      console.debug("hiding secondary...");
      secondary.classList.remove("hidden");
    } else {
      console.debug("showing secondary...");
      secondary.classList.add("hidden");
    }
  }
}
