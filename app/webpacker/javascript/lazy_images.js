import 'lazysizes';

// By default lazy-loaded images are hidden (to support JS
// being disabled). If JS is enabled, we show them.
document.querySelectorAll(".lazyload").forEach((img) => {
  img.classList.add("visible");
});
