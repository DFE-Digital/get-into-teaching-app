import { Application } from 'stimulus' ;
import TalkToUsController from 'talk-to-us_controller.js';

describe('TalkToUsController', () => {

    document.body.innerHTML = 
    `
    <section data-controller="talk-to-us" id="element">
        <div data-target="talk-to-us.chat" id="chat">
            <a href="#" data-action="click->talk-to-us#startChat" id="startChat">Chat Online</a>
        </div>
    </section>
    `;

    const open = jest.fn();
    const application = Application.start();
    application.register('talk-to-us', TalkToUsController);

    beforeEach(() => {
        jest.spyOn(global, "window", "get").mockImplementation(() => ({ open }));
    });

    it("makes the controller element visible", () => {
        var element = document.getElementById('element');
        expect(element.classList).toContain('visible');
    });

    describe("startChat", () => {
        it("opens the chat session", () => {
            var startChat = document.getElementById("startChat");
            startChat.click();
            const url = "https://gov.klick2contact.com/v03/launcherV3.php?p=DfE&d=971&ch=CH&psk=chat_a2&iid=STC&srbp=0&fcl=0&r=Static&s=https://gov.klick2contact.com/v03&u=&wo=&uh=&pid=82&iif=0";
            const target = "Get into teaching: Chat online";
            const features = "menubar=no,location=yes,resizable=yes,scrollbars=no,status=yes,width=340,height=480";
            expect(open).toBeCalledWith(url, target, features);
        });
    });
});