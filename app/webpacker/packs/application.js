require.context('../fonts', true) ;
require.context('../images', true) ;

import '../styles/application.scss';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import { initAll } from 'govuk-frontend';

Rails.start();
Turbolinks.start();

initAll();

import "controllers";
