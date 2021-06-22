import EventSearchButtonController from 'event_search_button_controller.js';
import { Application } from 'stimulus';

describe('EventSearchButtonController', () => {
  document.body.innerHTML = `
    <div class="search" data-controller="event-search-button">
      <form class="new_events_search" id="new_events_search" action="/events/search#searchforevents" accept-charset="UTF-8" method="get">
        <input name="utf8" type="hidden" value="✓">
        <div class="search__controls" data-controller="conditional-field" data-conditional-field-mode="hide" data-conditional-field-expected="">
          <div>
            <label for="events_search_type">Event type</label>
            <select data-action="event-search-button#parameterChanged" name="events_search[type]" id="events_search_type"><option value="">All events</option></select>
          </div>
          <div>
            <label for="events_search_distance">Location</label>
            <select data-action="conditional-field#toggle event-search-button#parameterChanged" data-conditional-field-target="source" name="events_search[distance]" id="events_search_distance"><option selected="" value="">Nationwide</option></select>
          </div>
          <div data-conditional-field-target="showhide" class="hidden">
            <label for="events_search_postcode">Postcode</label>
            <input data-action="event-search-button#parameterChanged" type="text" name="events_search[postcode]" id="events_search_postcode" disabled="">
          </div>
          <div>
            <label for="events_search_month">Month</label>
            <select data-action="event-search-button#parameterChanged" name="events_search[month]" id="events_search_month"><option selected="" value="2021-06">June 2021</option></select>
          </div>
        </div>
       <button class="disabled-button" id="updateResultsButton" data-event-search-button-target="updateResultsButton">Update
        results <span class="fas fa-sync"></span></button>
      </form>
    </div>
`;

  let updateResultsButton;

  beforeEach(() => {
    const application = Application.start();
    application.register('event-search-button', EventSearchButtonController);
    updateResultsButton = document.getElementById('updateResultsButton');
  });

  describe('on connect', () => {
    it('updates the "Update results" button style to disabled', () => {
      expectButtonToBeDisabled();
    });
  });

  describe('when "Event type" select value changed', () => {
    it('updates the "Update results" button style to enabled', () => {
      expectButtonToBeDisabled();
      simulateEventOnElement(
        document.getElementById('events_search_type'),
        'change'
      );
      expectButtonToBeEnabled();
    });
  });

  describe('when "Location" select value changed', () => {
    it('updates the "Update results" button style to enabled', () => {
      expectButtonToBeDisabled();
      simulateEventOnElement(
        document.getElementById('events_search_distance'),
        'change'
      );
      expectButtonToBeEnabled();
    });
  });

  describe('when "Month" select value changed', () => {
    it('updates the "Update results" button style to enabled', () => {
      expectButtonToBeDisabled();
      simulateEventOnElement(
        document.getElementById('events_search_month'),
        'change'
      );
      expectButtonToBeEnabled();
    });
  });

  describe('when "Postcode" input value changed', () => {
    it('updates the "Update results" button style to enabled', () => {
      expectButtonToBeDisabled();
      simulateEventOnElement(
        document.getElementById('events_search_postcode'),
        'input'
      );
      expectButtonToBeEnabled();
    });
  });

  function expectButtonToBeEnabled() {
    expect(updateResultsButton.classList).not.toContain('disabled-button');
    expect(updateResultsButton.classList).toContain('request-button');
  }

  function expectButtonToBeDisabled() {
    expect(updateResultsButton.classList).toContain('disabled-button');
    expect(updateResultsButton.classList).not.toContain('request-button');
  }

  function simulateEventOnElement(element, event) {
    const eventToDispatch = new Event(event);
    element.dispatchEvent(eventToDispatch);
  }
});
