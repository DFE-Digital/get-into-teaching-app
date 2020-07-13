import { Application } from 'stimulus' ;
import AccordionController from 'accordion_controller.js' ;

describe('AccordionController', () => {

    document.body.innerHTML = 
    `
    <div data-controller="accordion">
        <div class="steps-header" id="step-1" data-action="click->accordion#toggle" data-target="accordion.header">
            <h1>
                <div class="steps-header__number"><span>1</span></div>
                Header 1
                <i id="collapsable-icon-1" class="fas fa-chevron-up"></i>
            </h1>
        </div>
        <div id="collapsable-content-1" class="collapsable" data-target="accordion.content">
            Content 1
        </div>
        <div class="steps-header" id="step-2" data-action="click->accordion#toggle" data-target="accordion.header">
            <h1>
                <div class="steps-header__number"><span>2</span></div>
                Header 2
                <i id="collapsable-icon-2" class="fas fa-chevron-up"></i>
            </h1>
        </div>
        <div id="collapsable-content-2" class="collapsable" data-target="accordion.content">
            Content 2
        </div>
        <div class="steps-header" id="step-3" data-action="click->accordion#toggle" data-target="accordion.header">
            <h1>
                <div class="steps-header__number"><span>2</span></div>
                Header 3
                <i id="collapsable-icon-3" class="fas fa-chevron-up"></i>
            </h1>
        </div>
        <div id="collapsable-content-3" class="collapsable" data-target="accordion.content">
            Content 3
        </div>
    </div>   
    ` ;

    const application = Application.start() ;
    application.register('accordion', AccordionController) ;


    describe("when first loaded", () => {
        it("only first step should be opened", () => {
            const headers = document.getElementsByClassName('steps-header');
            for(let i=0;i<headers.length;i+=1){
                let icons = headers[i].getElementsByTagName('i');
                if(!icons.length) break;
                let icon = icons[0];
                if(i === 0) {
                    expect(icon.className).toContain('fa-chevron-up');
                } else {
                    expect(icon.className).toContain('fa-chevron-down');
                }
            }
        });
    })

    describe("when open header is toggled", () => {
        it("should close", () => {
            let headers = document.getElementsByClassName('steps-header');
            let icon = headers[0].getElementsByTagName('i')[0];
            expect(icon.className).toContain('fa-chevron-up');
            headers[0].click();
            expect(icon.className).toContain('fa-chevron-down');
        });
    });

});

