import '@stimulus/polyfills';
import '../styles/application.scss';
import 'polyfills/ie8.js';
import 'polyfills/objectFitPolyfill.basic.min.js';
import 'javascript/object_fit.js';
import 'javascript/lazy_images.js';
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';

import 'controllers';

require.context('../fonts', true);
require.context('../images', true);

Rails.start();
Turbolinks.start();
