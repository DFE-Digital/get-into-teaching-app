// Ensure skip-links behave correctly when using VoiceOver on iOS or TalkBack on
// Android. See https://axesslab.com/skip-links/ for a discussion of the issue
// and suggested fixes (including the one below from Mike Foskett).

(_ => {
  const skip_lnk = document.querySelector('.skiplink');
  if (!skip_lnk) return false;
  skip_lnk.addEventListener('click', e => {
    e.preventDefault();
    const to_obj = document.getElementById(skip_lnk.href.split('#')[1]);
    if (to_obj) {
      to_obj.setAttribute('tabindex', '-1');
      to_obj.addEventListener('blur', e => {
        to_obj.removeAttribute('tabindex');
      }, {
        once: true
      });
      to_obj.focus();
    }
  });
})();
