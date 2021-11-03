import lazySizes from 'lazysizes';
lazySizes.cfg.init = false;

lazySizes.init();

document.addEventListener('turbolinks:load', function () {
  lazySizes.init();
});
