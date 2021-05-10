import InternalEventsController from 'internal_events_controller.js';
import { Application } from 'stimulus';

describe('InternalEventsController', () => {
  document.body.innerHTML = `
    <form class="new_internal_event" id="new_internal_event" data-controller="internal-events">
      <input id="internal-event-name-field" class="govuk-input" data-internal-events-target="name"/>
      <input class="datetime govuk-input" data-internal-events-target="startAt" type="datetime-local" name="internal_event[start_at]" id="internal_event_start_at"/>
      <input id="internal-event-readable-id-field" class="govuk-input" aria-describedby="internal-event-readable-id-hint" data-internal-events-target="partialUrl" type="text" name="internal_event[readable_id]"/>
      <button id="generate" name="button" type="button" class="button form-button" data-target="internal-events.generateButton" data-action="click->internal-events#populatePartialUrl">Generate partial <span>URL</span></button>
    </form>
  `;

  const application = Application.start();
  application.register('internal-events', InternalEventsController);

  describe('clicking "generate partial URL" button', () => {
    describe('start at time is selected', () => {
      beforeEach(
        () =>
          (document.getElementById('internal_event_start_at').value =
            '2021-05-15T10:51')
      );

      it('replaces name internal whitespace with hyphens', () => {
        document.getElementById('internal-event-name-field').value =
          'event     name';

        document.getElementById('generate').click();

        const partialUrlFieldValue = document.getElementById(
          'internal-event-readable-id-field'
        ).value;
        expect(partialUrlFieldValue).toBe('210515-event-name');
      });

      it('trims name surrounding whitespace', () => {
        document.getElementById('internal-event-name-field').value =
          '  event name  ';

        document.getElementById('generate').click();

        const partialUrlFieldValue = document.getElementById(
          'internal-event-readable-id-field'
        ).value;
        expect(partialUrlFieldValue).toBe('210515-event-name');
      });

      it('converts characters to lower case', () => {
        document.getElementById('internal-event-name-field').value =
          'EVENT NAME';

        document.getElementById('generate').click();

        const partialUrlFieldValue = document.getElementById(
          'internal-event-readable-id-field'
        ).value;
        expect(partialUrlFieldValue).toBe('210515-event-name');
      });
    });

    describe('start at is not set', () => {});
  });
});
