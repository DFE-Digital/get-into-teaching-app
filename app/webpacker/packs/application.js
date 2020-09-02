require.context('../fonts', true) ;
require.context('../images', true) ;

import '@stimulus/polyfills'
import '../styles/application.scss';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

Rails.start();
Turbolinks.start();

import "controllers";
