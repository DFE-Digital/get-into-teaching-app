import lazySizes from 'lazysizes';
lazySizes.cfg.init = false;

document.addEventListener('turbo:load', function () {
  lazySizes.init();
});
