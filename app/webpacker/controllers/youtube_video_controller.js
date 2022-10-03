import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['preview', 'video'];

  connect() {
    if (this.hasPreviewTarget) {
      this.showPreview();
    }
  }

  play() {
    this.videoTarget.classList.remove('hidden');
    this.previewTarget.classList.add('hidden');
  }

  showPreview() {
    this.videoTarget.classList.add('hidden');
    this.previewTarget.classList.remove('hidden');
  }
}
