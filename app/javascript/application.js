import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import dfeAutocomplete from "dfe-autocomplete";

import './controllers';

import './lib/perfume';

Rails.start();
Turbolinks.start();

document.addEventListener('turbolinks:load', function () {
  dfeAutocomplete( { rawAttribute: true, autoselect: false } );
}, false);
