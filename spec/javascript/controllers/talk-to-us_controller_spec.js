import { Application } from 'stimulus' ;
import TalkToUsController from 'talk-to-us_controller.js';

describe('TalkToUsController', () => {

    document.body.innerHTML = 
    `
    <section id="talk-to-us" class="talk-to-us" data-controller="talk-to-us">

        <div class="talk-to-us__inner__table__column" data-target="talk-to-us.chat" id="1">
            <p>
                <b>Chat online</b> <br/>
                If you have questions about getting into teaching, we can help you get the answers you need with our one-to-one live online chat service, 
                Monday-Friday between 8.30am and 5pm.
            </p>
            <a href="#" class="call-to-action-button" data-action="click->talk-to-us#startChat">
                Chat <span>online</span>
            </a>
        </div>

        <div class="talk-to-us__inner__table__column" data-target="talk-to-us.tta" id="2">
            <p>
                <b>Sign up to talk to a teacher training adviser</b> <br/>
                If you're ready to get into teaching, you can get support from a dedicated and experienced teaching professional 
                who can guide you through each step of the process.
            </p>
            <p>
                If you’re returning to teaching and are qualified to teach maths, physics or languages, you can also get support by using this service.
            </p>
            <%= tta_service_link class: "call-to-action-button" do %>
                Sign up to talk to a teacher training <span>adviser</span>
            <% end %>
        </div>

    </section>
    `;

    const application = Application.start() ;
    application.register('talk-to-us', TalkToUsController) ;

    describe("when first loaded", () => {

        it("should make the chat section visible", () => {
            var chat = document.getElementById('1');
            expect(chat.style.display).toContain('inline-block');
        });

    });

});