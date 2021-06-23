import { Application } from 'stimulus';
import LastStepController from 'last_step_controller';

describe('LastStepController', () => {
  document.body.innerHTML = `
    <form>
      <div data-controller="last-step" data-last-step-continue="continue" data-last-step-complete="complete">
        <div data-action="click->last-step#updateSubmit">
          <fieldset>
            <legend>Test option</legend>

            <div>
              <label>
                <input type="radio" value="yes" id="yes-radio"> Yes
              </label>
            <div>

            <div data-last-step-target="complete">
              <div>
                <label>
                  <input type="radio" value="no" id="no-radio"> No
                </label>
              </div>
            <div>
        </div>
      </div>

      <button type="submit" id="button">undetermined</button>
    </form>
  `;

  beforeEach(() => {
    const application = Application.start();
    application.register('last-step', LastStepController);
  });

  function buttonLabel() {
    return document.getElementById('button').innerHTML;
  }

  function buttonDisableText() {
    return document.getElementById('button').dataset.disableWith;
  }

  describe('When no button clicked', () => {
    it('should have default message', () => {
      expect(buttonLabel()).toEqual('continue');
      expect(buttonDisableText()).toEqual('continue');
    });
  });

  describe('Clicking normal radio', () => {
    beforeEach(() => {
      document.getElementById('yes-radio').click();
    });

    it('should set message to continue', () => {
      expect(buttonLabel()).toEqual('continue');
      expect(buttonDisableText()).toEqual('continue');
    });
  });

  describe('Clicking radio to end wizard', () => {
    beforeEach(() => {
      document.getElementById('no-radio').click();
    });

    it('should set message to complete', () => {
      expect(buttonLabel()).toEqual('complete');
      expect(buttonDisableText()).toEqual('complete');
    });
  });
});
