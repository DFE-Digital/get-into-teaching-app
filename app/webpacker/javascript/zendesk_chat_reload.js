// Ensure the Zendesk Chat widget gets reloaded on page change.
// Without this, it works on the first page load but then does not
// appear if you change page and try and open it.
window.addEventListener('turbolinks:before-render', function () {
  window.zEACLoaded = undefined;
  window.$zopim = undefined;
});
