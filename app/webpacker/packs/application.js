require.context('../fonts', true) ;
require.context('../images', true) ;
import '../styles/application.scss';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

Rails.start();
Turbolinks.start();

// FIXME straight copy from prototype

var hiddenClass = 'hidden';
var closedClass = 'closed';
var inactiveClass = 'inactive';

function removeClass ( el, className ) {
  el.classList.remove( className );
}

function addClass ( el, className ) {
  el.classList.add( className );
}

function show ( el ) {
  removeClass( el, hiddenClass );
  removeClass( el, inactiveClass );
}

function hide ( el ) {
  addClass( el, hiddenClass );
  addClass( el, inactiveClass );
}

function open ( el, twiddle ) {
  removeClass( el, closedClass );
  twiddle.innerText = "-";
}

function close ( el, twiddle ) {
  addClass( el, closedClass );
  twiddle.innerText = "+";
}

function toggleMainNav (el) {
  var nav = el;

  return function toggleMainNavHelper () {
    if ( nav.className.indexOf( hiddenClass ) !== -1 ) {
      show( nav );
      return;
    }

    hide( nav );
  }
}

function toggleStepPanel (el) {
  var panel = el.parentNode;
  var twiddle = el.childNodes[el.childNodes.length - 1];

  addClass( el.parentNode, closedClass );
  twiddle.innerText = "+";

  return function toggleStepPanelHandler () {
    if ( panel.className.indexOf( closedClass ) !== -1 ) {
      open ( panel, twiddle );
      return;
    }

    close ( panel, twiddle );
  }
}

var mainNav = document.getElementById( 'mainNav' );
document.getElementById( 'mainNavToggle' ).addEventListener( 'click', toggleMainNav( mainNav ), false );

var toggles = document.getElementsByClassName('step-by-step-toggle');
for (i = 0; i < toggles.length; i++) {
    toggles[i].addEventListener('click', toggleStepPanel(toggles[i]), false);
}
