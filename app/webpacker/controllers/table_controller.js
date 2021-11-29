import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    this.addTableHeadingScopes();
  }

  addTableHeadingScopes() {
    for (const th of this.tableHeadings) {
      if (!th.scope && th.textContent) {
        th.scope = 'col';
      }
    }
  }

  get tableHeadings() {
    return document.querySelectorAll('.markdown table thead > tr > th');
  }
}
