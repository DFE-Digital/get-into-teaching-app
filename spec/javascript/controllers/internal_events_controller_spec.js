import InternalEventsController from 'internal_events_controller.js';
import { Application } from 'stimulus';

describe('InternalEventsController', () => {
  document.body.innerHTML = `
    <form class="new_internal_event" id="new_internal_event" data-controller="internal-events">
      <input id="internal-event-name-field" class="govuk-input" data-internal-events-target="name"/>
      <input class="datetime govuk-input" data-internal-events-target="startAt" type="datetime-local" name="internal_event[start_at]" id="internal_event_start_at"/>
      <input id="internal-event-readable-id-field" class="govuk-input" aria-describedby="internal-event-readable-id-hint" data-internal-events-target="partialUrl" type="text" name="internal_event[readable_id]"/>
      <span class="govuk-error-message hidden" id="internal-generate-url-error" data-internal-events-target="errorMessage">
        <span class="govuk-visually-hidden">Error: </span>Name and Start at fields must have values in order to generate partial URL
      </span>
      <button id="generate" name="button" type="button" class="button form-button" data-target="internal-events.generateButton" data-action="click->internal-events#populatePartialUrl">Generate partial <span>URL</span></button>
    </form>
  `;

  const application = Application.start();
  application.register('internal-events', InternalEventsController);

  describe('clicking "generate partial URL" button', () => {
    afterEach(() => {
      document.getElementById('internal_event_start_at').value = '';
      document.getElementById('internal-event-name-field').value = '';
    });

    describe('event name and start at have values', () => {
      beforeEach(
        () =>
          (document.getElementById('internal_event_start_at').value =
            '2021-05-15 10:51')
      );

      describe('name', () => {
        it('replaces internal whitespace with hyphens', () => {
          document.getElementById('internal-event-name-field').value =
            'event     name';

          document.getElementById('generate').click();

          const partialUrlFieldValue = document.getElementById(
            'internal-event-readable-id-field'
          ).value;
          expect(partialUrlFieldValue).toBe('210515-event-name');
        });

        it('trims surrounding whitespace', () => {
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

        it('removes extra hyphens', () => {
          document.getElementById('internal-event-name-field').value =
            'event - name - with-hyphens';

          document.getElementById('generate').click();

          const partialUrlFieldValue = document.getElementById(
            'internal-event-readable-id-field'
          ).value;
          expect(partialUrlFieldValue).toBe('210515-event-name-withhyphens');
        });

        it('removes characters that are not alphanumeric or whitespace', () => {
          document.getElementById('internal-event-name-field').value =
            'event?name:with (extra@characters)_';

          document.getElementById('generate').click();

          const partialUrlFieldValue = document.getElementById(
            'internal-event-readable-id-field'
          ).value;
          expect(partialUrlFieldValue).toBe(
            '210515-eventnamewith-extracharacters'
          );
        });
      });

      it('previous error message is removed', () => {
        document.getElementById('internal-event-name-field').value =
          'event name';
        const errorMessage = document.getElementById(
          'internal-generate-url-error'
        );
        errorMessage.style.display = 'block';

        document.getElementById('generate').click();

        expect(errorMessage.style.display).toBe('none');
      });
    });

    describe('start at has no value', () => {
      beforeEach(() => {
        document.getElementById('internal-event-name-field').value = 'name';
      });

      it('displays error message', () => {
        document.getElementById('generate').click();

        const errorMessage = document.getElementById(
          'internal-generate-url-error'
        );
        expect(errorMessage.style.display).toBe('block');
      });

      it('empties partial URL field value', () => {
        const partialUrl = document.getElementById(
          'internal-event-readable-id-field'
        );
        partialUrl.value = 'test';

        document.getElementById('generate').click();

        expect(partialUrl.value).toBe('');
      });
    });

    describe('name has no value', () => {
      beforeEach(() => {
        document.getElementById('internal_event_start_at').value =
          '2021-05-15T10:51';
      });

      it('displays error message', () => {
        document.getElementById('generate').click();

        const errorMessage = document.getElementById(
          'internal-generate-url-error'
        );

        expect(errorMessage.style.display).toBe('block');
      });

      it('empties partial URL field value', () => {
        const partialUrl = document.getElementById(
          'internal-event-readable-id-field'
        );
        partialUrl.value = 'test';

        document.getElementById('generate').click();

        expect(partialUrl.value).toBe('');
      });
    });
  });
});
