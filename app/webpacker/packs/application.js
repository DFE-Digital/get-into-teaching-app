require.context('../fonts', true) ;
require.context('../images', true) ;

import '@stimulus/polyfills'
import '../styles/application.scss';
import 'polyfills/ie8.js';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

Rails.start();
Turbolinks.start();

import "controllers";

document.addEventListener("turbolinks:load", function() {
    const links = document.querySelectorAll('a');
    links.forEach((l) => {
        if (l.getAttribute('href')?.startsWith('#')) {
            l.dataset.turbolinks = "false"
        }
    });
})