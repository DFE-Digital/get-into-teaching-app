import { Application } from 'stimulus' ;
import VideoController from 'video_controller.js' ;

describe('AccordionController', () => {

    document.body.innerHTML = 
    `
    <body data-controller="video">
        <div class="video-overlay" data-target="video.player" data-action="click->video#close">
            <div class="video-overlay__background">   
            </div>
            <div class='video-overlay__video-container'>
                <div class="video-overlay__video-container__wrapper">
                    <iframe data-target="video.iframe"
                        width="800" 
                        height="450"
                        src="https://www.youtube.com/embed/aGd_Rrs-qNY" 
                        frameborder="0" 
                        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
                        allowfullscreen>
                    </iframe>
                </div>
                <div class="video-overlay__video-container__dismiss">
                    <div class="icon-video-close" data-action="click->video#close"></div>
                </div>
            </div>
        </div>
    </body>
    `

    const application = Application.start() ;
    application.register('video', VideoController) ;


    describe("when first loaded", () => {
        it("something should happen", () => {
        })
    })

});