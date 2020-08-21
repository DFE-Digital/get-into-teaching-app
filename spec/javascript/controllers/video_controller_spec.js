import { Application } from 'stimulus' ;
import VideoController from 'video_controller.js' ;

describe('AccordionController', () => {

    document.body.innerHTML = 
    `
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
            <button class="video-overlay__video-container__dismiss" data-target="video.close" data-action="click->video#close">
                <div class="icon-video-close"><span class="visually-hidden">Close video</span></div>
            </button>
            <a class="visually-hidden" href="#">
                Close
            </a>
        </div>
    </div>
    `

    const application = Application.start() ;
    application.register('video', VideoController) ;

    describe("when first loaded", () => {
        it("removes the target attribute from video links", () => {
            let vidlink = document.getElementsByTagName('a');
            expect(vidlink[0].getAttribute('target')).toBe(null);
        })
    });

    describe("when video link is clicked", () => {
        it("swaps out the youtube url with the embedded version", () => {
            let vidlink = document.getElementsByTagName('a')[0];
            vidlink.click();
            let iframe = document.getElementsByTagName('iframe')[0];
            let iframesrc = iframe.getAttribute('src');
            expect(iframesrc).toContain('https://www.youtube.com/embed/');
        })
        it("makes the video player visible", () => {
            let videoplayer = document.getElementById('the-video-player');
            expect(videoplayer.style.display).toBe('flex');
        });
    });

    describe("when the dismiss button is clicked", () => {
        it("sets the video player display to hidden", () => {
            let closeButton = document.getElementById('close-button');
            closeButton.click();
            let videoplayer = document.getElementById('the-video-player');
            expect(videoplayer.style.display).toBe('none');
        })
    });

    describe("when the overlay is clicked and video is open", () => {
        it("sets the video player display to hidden", () => {
            let vidlink = document.getElementsByTagName('a')[0];
            vidlink.click();
            let videoplayer = document.getElementById('the-video-player');
            videoplayer.click();
            expect(videoplayer.style.display).toBe('none');
        })
    });
    

});