// Ensure skip-links behave correctly when using VoiceOver on iOS or TalkBack on
// Android. See https://axesslab.com/skip-links/ for a discussion of the issue
// and suggested fixes (including the one below from Mike Foskett).

((_) => {
  const skiplink = document.querySelector('.skiplink');
  if (!skiplink) return false;
  skiplink.addEventListener('click', (e) => {
    e.preventDefault();
    const obj = document.getElementById(skiplink.href.split('#')[1]);
    if (obj) {
      obj.setAttribute('tabindex', '-1');
      obj.addEventListener(
        'blur',
        (e) => {
          obj.removeAttribute('tabindex');
        },
        {
          once: true,
        }
      );
      obj.focus();
    }
  });
})();
