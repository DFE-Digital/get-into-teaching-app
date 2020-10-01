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
    if (window.scribble != undefined) {
      return;
    }

    window.scribble = (function(d, s, id) {var js,ijs=d.getElementsByTagName(s)[0];
    if(d.getElementById(id))return;js=d.createElement(s);
    js.id=id;js.src="//embed.scribblelive.com/widgets/embed.js";
    ijs.parentNode.insertBefore(js, ijs);}(document, 'script', 'scrbbl-js'));
  }

  get id() {
    return this.data.get('id');
  }
}
