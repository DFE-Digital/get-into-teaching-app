import '@stimulus/polyfills';
import "core-js/stable";
import "regenerator-runtime/runtime";
import '../styles/application.scss';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

import 'controllers';

require.context('../fonts', true);
require.context('../images', true);
require.context('../documents', true);

Rails.start();
Turbolinks.start();
