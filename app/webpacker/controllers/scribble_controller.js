import { Controller } from "stimulus" ;

export default class extends Controller {
  connect() {
    this.load();
  }

  load() {
    this.setId();
    this.initService();
  }

  setId() {
    this.element.classList.add('scrbbl-embed');
    this.element.dataset.src = this.id;
  }

  initService() {
    const scribble = document.createElement("script");
    scribble.id = "scrbbl-js";
    scribble.src = "//embed.scribblelive.com/widgets/embed.js";
    this.element.appendChild(scribble);
  }

  get id() {
    return this.data.get('id');
  }
}
