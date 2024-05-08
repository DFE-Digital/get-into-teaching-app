import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['header', 'content'];
  static values = {
    activeStep: Number,
  };

  connect() {
    this.setup();
  }

  toggle(event) {
    this.toggleCollapsable(
      event.target.closest('.step').getAttribute('data-id'),
    );
  }

  toggleCollapsable(step) {
    const stepElement = this.retrieveStepElement(step);

    if (this.stepActive(stepElement)) {
      this.deactivate(stepElement);
    } else {
      this.activate(stepElement);
    }
  }

  activate(stepElement) {
    stepElement.classList.remove('inactive');
  }

  deactivate(stepElement) {
    stepElement.classList.add('inactive');
  }

  retrieveStepElement(step) {
    return document.getElementById('step-' + step);
  }

  stepActive(step) {
    return !step.classList.contains('inactive');
  }

  setup() {
    const selector = this.stepFromURI() || this.stepFromAttr() || '.step';

    document
      .querySelectorAll(selector)
      .forEach((step) => this.deactivate(step));
  }

  stepFromURI() {
    const stepMatcher = /step-([\d])/;
    const uriFragment = window.location.hash.match(stepMatcher);

    if (uriFragment) {
      const stepFromHashId = uriFragment[0];

      return `.step:not(#${stepFromHashId})`;
    }

    return false;
  }

  stepFromAttr() {
    if (this.activeStepValue) {
      const stepFromDataAttr = `step-${this.activeStepValue}`;

      return `.step:not(#${stepFromDataAttr})`;
    }

    return false;
  }

  allStepElements() {
    return document.querySelectorAll('.step');
  }
}
