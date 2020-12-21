import { Application } from 'stimulus' ;
import AccordionController from 'accordion_controller.js' ;

describe('AccordionController', () => {
    document.body.innerHTML = `
    <div data-controller="accordion" data-accordion-active-step-value="2">
        <section id="step-1" class="step" data-id="1">
            <button id="button-1" class="step-header" data-action="click->accordion#toggle" data-accordion-target="header">
              Button 1
            </button>
            <div id="collapsable-content-1" data-accordion-target="content">
                Content 1
            </div>
        </section>

        <section id="step-2" class="step" data-id="2">
            <button id="button-2" class="step-header" data-action="click->accordion#toggle" data-accordion-target="header">
              Button 2
            </button>
            <div id="collapsable-content-2" data-accordion-target="content">
                Content 2
            </div>
        </section>

        <section id="step-3" class="step" data-id="3">
            <button id="button-3" class="step-header" data-action="click->accordion#toggle" data-accordion-target="header">
              Button 3
            </button>
            <div id="collapsable-content-3" data-accordion-target="content">
                Content 3
            </div>
        </section>
    </div>
    `;

    const application = Application.start() ;
    application.register('accordion', AccordionController) ;

    describe("when first loaded with 'active' step set to '2'", () => {
        it("only first step should be opened", () => {
          expect(document.getElementById("step-2").classList).not.toContain("inactive");

          expect(document.getElementById("step-1").classList).toContain("inactive");
          expect(document.getElementById("step-3").classList).toContain("inactive");
        });
    })

    describe("when open header is toggled", () => {
        it("should close", () => {
          expect(document.getElementById("step-2").classList).not.toContain("inactive");

          document.getElementById("button-2").click();

          expect(document.getElementById("step-2").classList).toContain("inactive");
        });
    });

    describe("when closed header is toggled", () => {
        it("should open", () => {
          expect(document.getElementById("step-3").classList).toContain("inactive");

          document.getElementById("button-3").click();

          expect(document.getElementById("step-3").classList).not.toContain("inactive");
        });
    });
});
