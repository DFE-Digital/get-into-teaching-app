import { Application } from 'stimulus';
import AspectRatioController from 'aspect_ratio_controller';

describe('AspectRatioController', () => {
  let wrapper;

  const setupHtml = (width, height) => {
    document.body.innerHTML = `
      <div id="wrapper" data-controller="aspect-ratio" data-aspect-ratio-width-value="${width}" data-aspect-ratio-height-value="${height}">
        <iframe></iframe>
      </div>
    `
  }

  beforeEach(() => {
    setupHtml(100, 200)
    const application = Application.start()
    application.register('aspect-ratio', AspectRatioController)
    wrapper = document.getElementById('wrapper')
  })

  describe('with a valid aspect ratio', () => {
    it('sets the aspect-ratio class on the wrapper', () => {
      expect(wrapper.classList.contains('aspect-ratio')).toBe(true)
    })

    it('enforces the aspect ratio through padding-bottom', () => {
      expect(wrapper.style.paddingBottom).toEqual('200%')
    })
  })
})
