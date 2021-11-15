import AnalyticsBaseController from './analytics_base_controller';

export default class extends AnalyticsBaseController {
  // We only load Google Optimize when on paths that
  // are running an experiment.
  static paths = ['/test/a', '/test/b'];

  get serviceId() {
    return this.getServiceId('google-optimize-id');
  }

  get serviceFunction() {
    return window.optimize;
  }

  get cookieCategory() {
    return 'non-functional';
  }

  initService() {
    const script = document.createElement('script');
    script.src = `https://www.googleoptimize.com/optimize.js?id=${this.serviceId}`;
    document.body.appendChild(script);
    // No-op as we pull in an external script.
    window.optimize = () => {};
  }

  get isEnabled() {
    const experimentPath = this.constructor.paths.includes(
      window.location.pathname
    );
    return !!this.serviceId && experimentPath;
  }

  sendEvent() {
    // No-op as Google Optimize can be configured to notice page changes.
  }
}
