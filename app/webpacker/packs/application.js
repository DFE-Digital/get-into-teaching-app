import "regenerator-runtime/runtime";
import '../styles/application.scss';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import dfeAutocomplete from "dfe-autocomplete";

import 'controllers';

require.context('../fonts', true);
require.context('../images', true);
require.context('../documents', true);

require('../javascript/perfume');

Rails.start();
Turbolinks.start();

document.addEventListener('turbolinks:load', function () {
  dfeAutocomplete( { rawAttribute: true, autoselect: false } );
}, false);
