import { Controller } from "stimulus"

export default class extends Controller {

    static targets = ["header", "content"]

    connect() {
        this.foldUp();
    }

    toggle(event) {
        const header = event.target.closest('.steps-header');
        var elementId = header.getAttribute('id')
        var frags = elementId.split('-');
        var last = frags[frags.length-1];
        this.toggleCollapsable(last);
}

    toggleCollapsable(item) {

        //toggle icon
        var iconName = 'collapsable-icon-' + item; 
        var icon = document.getElementById(iconName);
        if(icon) {
            var currentIconClass = icon.getAttribute('class');
            if(currentIconClass === 'fas fa-chevron-up') {
                icon.setAttribute('class','fas fa-chevron-down');
            } else {
                icon.setAttribute('class','fas fa-chevron-up');
            }
        }

        //toggle content
        var contentName = 'collapsable-content-' + item;
        var content = document.getElementById(contentName);
        if(content) {
            if(content.style.display === 'block') {
                content.style.display = 'none';
            } else {
                content.style.display = 'block';
            }
        }
    }

    foldUp() {
        var stepnumber;
        var dontScroll = false;
        if(window.location.hash) {
            stepnumber = window.location.hash.replace('#step-','');
        }

        if(!stepnumber) {
            stepnumber = "1";
            dontScroll = true;
        }
        
        for(var i=1; i<= this.contentTargets.length; i+=1) {
            var elementId = this.contentTargets[i-1].getAttribute('id');
            if(stepnumber === i.toString()) continue;
            if(elementId) {
                var frags = elementId.split('-');
                var last = frags[frags.length-1];
                this.toggleCollapsable(last);
            }
        }

        if(!dontScroll) {
            this.element.getElementById('step-' + stepnumber).scrollIntoView(true,{smooth:true});
        }
    }

}