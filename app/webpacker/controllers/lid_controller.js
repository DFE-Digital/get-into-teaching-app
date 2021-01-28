import ImagePixelBaseController from './image_pixel_base_controller';

export default class extends ImagePixelBaseController {
  static path = '/one.png';
  static domains = [
    'https://pixelg.adswizz.com',
    'https://tracking.audio.thisisdax.com',
  ];

  get serviceId() {
    return this.getServiceId('lid-id');
  }

  get serviceFunction() {
    return window.lid;
  }

  get event() {
    return this.data.get('event');
  }

  initService() {
    // Empty as this is an image tracking pixel.
    window.lid = () => {};
  }

  imgSrc(domain, event) {
    return `${domain}${this.constructor.path}&?client=GovernmentDFE&action=cs&j=0&event=${event}`;
  }

  sendEvent() {
    this.constructor.domains.forEach((domain) =>
      this.loadPixel(this.imgSrc(domain, this.event))
    );
  }
}
