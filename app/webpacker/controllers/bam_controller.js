import ImagePixelBaseController from './image_pixel_base_controller';

export default class extends ImagePixelBaseController {
  static ids = [
    '3g6cKlN4VmA4FAL/1SlB2',
    'nis3acYUOeaVpuG/RPOzc',
    'cfZRDrq9SRKrBVU/FpASD',
    'V8R6qhowRkziLjG/Eg0N9',
    'X4KBgSPXbMgXXon/CRJA9',
    'MP8YKC867PjN6Rl/BTYf2',
    '5DRPPG8Sakm5o8i/4yVXp',
    'fSSR83JdeURiiQ3/YNZ99',
    'nwQx6WBpT23FfAn/1hnVZ',
    '3BSBg0IMtWQmpkb/wFCtJ',
    '1MbhNg55GhAVDkd/3VrFR',
    'Ae4BnnTfkvZ5pRz/dbgOi',
  ];

  get serviceId() {
    return this.getServiceId('bam-id');
  }

  get serviceFunction() {
    return window.bam;
  }

  initService() {
    // Empty as this is an image tracking pixel.
    window.bam = () => {};
  }

  sendEvent() {
    this.constructor.ids.forEach((id) =>
      this.loadPixel(`https://linkbam.uk/m/${id}.png`)
    );
  }
}
