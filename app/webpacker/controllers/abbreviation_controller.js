import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.addClickHandlersToAbbrElements();
  }

  addClickHandlersToAbbrElements() {
    const abbrs = this.element.querySelectorAll('abbr');

    const replace = (event) => {
      // get the abbr element and pull its name from title
      const abbr = event.currentTarget;
      const name = abbr.getAttribute('title');

      // create a span with appropriate class that we can use
      // to replce the <abbr>. This would be easier with jQuery
      const replacementSpan = document.createElement('span');
      const replacementText = document.createTextNode(name);
      replacementSpan.appendChild(replacementText);
      replacementSpan.setAttribute('class', 'abbr-replacement');

      // finally replace the abbr element with the new span
      abbr.replaceWith(replacementSpan);
    };

    abbrs.forEach((abbr) => {
      abbr.addEventListener('click', replace, { once: true });
    });
  }
}
