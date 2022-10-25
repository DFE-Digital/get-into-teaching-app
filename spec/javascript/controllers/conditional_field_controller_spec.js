import { Application } from '@hotwired/stimulus';
import ConditionalFieldController from 'conditional_field_controller.js';

describe('ConditionalFieldController', () => {
  describe('toggleable field when it should hide', () => {
    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="conditional-field"
          data-conditional-field-mode="hide"
          data-conditional-field-expected="">

          <div>
            <select id="select"
                    data-conditional-field-target="source"
                    data-action="conditional-field#toggle">
              <option value="">-- Please choose --</option>
              <option value="1">First</option>
              <option value="2">Second</option>
            </select>
          </div>

          <div id="container" data-conditional-field-target="showhide">
            <input name="postcode" id="postcode" value="" />
          </div>
        </div>
      `;

      const application = Application.start();
      application.register('conditional-field', ConditionalFieldController);
    });

    describe('when the source is blank', () => {
      it('should be hidden', () => {
        const classes = document.getElementById('container').classList;
        expect(classes).toContain('hidden');
      });

      it('inner input should be disabled', () => {
        const disabled = document.getElementById('postcode').disabled;
        expect(disabled).toBe(true);
      });
    });

    describe('when the source field is not blank', () => {
      beforeEach(() => {
        const select = document.getElementById('select');
        select.value = 2;
        select.dispatchEvent(new Event('change'));
      });

      it('should not be hidden', () => {
        const classes = document.getElementById('container').classList;
        expect(classes).not.toContain('hidden');
      });

      it('inner input should not be disabled', () => {
        const disabled = document.getElementById('postcode').disabled;
        expect(disabled).toBe(false);
      });
    });
  });

  describe('toggleable field when it should show', () => {
    beforeEach(() => {
      document.body.innerHTML = `
        <div data-controller="conditional-field"
          data-conditional-field-mode="show"
          data-conditional-field-expected="">

          <div id="selectcontainer">
            <select id="select"
                    data-conditional-field-target="source"
                    data-action="conditional-field#toggle">
              <option value="">-- Please choose --</option>
              <option value="1">First</option>
              <option value="2">Second</option>
            </select>
          </div>

          <div id="container" data-conditional-field-target="showhide">
            <input name="postcode" id="postcode" value="" />
          </div>
        </div>
      `;

      const application = Application.start();
      application.register('conditional-field', ConditionalFieldController);
    });

    describe('when the source is blank', () => {
      it('should be not be hidden', () => {
        const classes = document.getElementById('container').classList;
        expect(classes).not.toContain('hidden');
      });

      it('inner input should not be disabled', () => {
        const disabled = document.getElementById('postcode').disabled;
        expect(disabled).toBe(false);
      });
    });

    describe('when the source field is not blank', () => {
      beforeEach(() => {
        const select = document.getElementById('select');
        select.value = 2;
        select.dispatchEvent(new Event('change'));
      });

      it('should be hidden', () => {
        const classes = document.getElementById('container').classList;
        expect(classes).toContain('hidden');
      });

      it('inner input should be disabled', () => {
        const disabled = document.getElementById('postcode').disabled;
        expect(disabled).toBe(true);
      });
    });
  });
});
