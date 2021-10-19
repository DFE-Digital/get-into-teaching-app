/* eslint-disable no-undef */
document.addEventListener('turbo:load', function (event) {
  if (typeof gtag === 'function') {
    gtag('config', 'UA-159214613-2', {
      page_path: event.data.url,
    });
  }
});
