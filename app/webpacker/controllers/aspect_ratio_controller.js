import { Controller } from 'stimulus';

export default class extends Controller {
  static values = {
    width: Number,
    height: Number,
  };

  connect() {
    this.verifyAspectRatio();
    this.setAspectRatio();
  }

  setAspectRatio() {
    this.element.className = 'aspect-ratio';
    this.element.style.paddingBottom = this.aspectRatio * 100 + '%';
  }

  verifyAspectRatio() {
    if (isNaN(this.widthValue) || isNaN(this.heightValue)) {
      throw new Error('width/height must be a number');
    }
  }

  get aspectRatio() {
    return this.heightValue / this.widthValue;
  }
}
