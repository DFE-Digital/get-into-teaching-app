import { Controller } from "stimulus"

export default class extends Controller {

    static targets = ["header", "content"]

    connect() {
        this.setup();
    }

    toggle(event) {
        this.toggleCollapsable(
            event
                .target
                .closest('.step')
                .getAttribute('data-id')
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
        return document.getElementById("step-" + step);
    }

    stepActive(step) {
        return !step.classList.contains('inactive');
    }

    setup() {
        // disable all the steps except the nominated one or the first
        const stepMatcher = /step-([\d])/;
        const stepFromHash = window.location.hash.match(stepMatcher);

        let activeStep = "step-1";

        if (stepFromHash) {
            activeStep = stepFromHash[0];
        }

        document
            .querySelectorAll(`.step:not(#${activeStep})`)
            .forEach(step => this.deactivate(step));
    }

    allStepElements() {
        return document.querySelectorAll('.step');
    }
}
