import sinon from 'sinon';

const params = new URLSearchParams(window.location.search);
const fakeBrowserTime = params.get('fake_browser_time');
const time = parseInt(fakeBrowserTime, 10);

if (!isNaN(time)) {
  sinon.useFakeTimers(time);
}
