import AnalyticsBaseController from "./analytics_base_controller"

export default class extends AnalyticsBaseController {
  get cookieCategory() {
    return 'non-functional';
  }

  loadPixel(src) {
    const img = document.createElement('img');
    img.src = src;
    img.width = 0;
    img.height = 0;
    img.style.display = 'none';
    this.element.appendChild(img);
  }
}
