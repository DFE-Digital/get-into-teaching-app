import { Application } from 'stimulus';
import AgeStepController from 'age_step_controller';

describe('AgeStepController', () => {
  beforeAll(() => {
    const application = Application.start();
    application.register('age-step', AgeStepController);
  })

  beforeEach(() => {
    window.ga = jest.fn()
    delete window.location
    window.location = new URL('https://www.example.com/age')
  })

  const setHtml = (gaId) => {
    if (gaId) {
      document.body.dataset.analyticsGaId = gaId
    }

    document.body.innerHTML = `
      <div
        data-controller="age-step"
        data-age-step-display-option-value="date_of_birth"
      ></div>`
  }

  describe('when analytics id is present', () => {
    beforeEach(() => { setHtml("ga-id-123") })

    it('sends a page view event to Google Analytics', () => {
      expect(window.ga).toHaveBeenCalledWith('send', {
        'hitType': 'pageview',
        'page': '/age/date_of_birth',
        'title': 'Get personalised to your inbox, age step (date_of_birth) | Get Into Teaching'
      })
    });
  })

  describe('when analytics id is an empty string', () => {
    beforeEach(() => { setHtml(' ') })

    it('does not send a page view event to Google Analytics', () => {
      expect(window.ga).not.toHaveBeenCalled()
    });
  })

  describe('when analytics id is undefined', () => {
    beforeEach(() => { setHtml(undefined) })

    it('does not send a page view event to Google Analytics', () => {
      expect(window.ga).not.toHaveBeenCalled()
    });
  })
});
