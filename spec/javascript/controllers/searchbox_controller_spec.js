import { Application } from 'stimulus';
import SearchboxController from 'searchbox_controller.js';

describe('SearchboxController', () => {
  const searchboxTemplate = `
    <div id="search" data-controller="searchbox" data-searchbox-search-input-id-value="searchbox__input" class="searchbox">
      <label for="searchbox__input" data-searchbox-target="label">Search</label>
      <div data-searchbox-target="searchbar"></div>
      <a data-action="searchbox#setup">Search</a>
    </div>
  `;

  const clickSearch = () => document.querySelector('a').click();

  beforeAll(() => {
    const application = Application.start();
    application.register('searchbox', SearchboxController);
  });

  beforeEach(() => {
    document.body.innerHTML = searchboxTemplate;
  });

  describe('initialising autocomplete', () => {
    beforeEach(() => {
      clickSearch();
    });

    it('should create autocomplete-wrapper div', () => {
      const autocompletes = document.querySelectorAll('.autocomplete__wrapper');
      expect(autocompletes.length).toBe(1);
    });

    it('adds an aria-label attribute to the input', () => {
      const input = document.querySelector('input');
      expect(input.ariaLabel).toEqual('Search');
    });
  });

  describe('typing in the search box', () => {
    let open;

    beforeEach(() => {
      open = jest.fn();
      const xhrMock = () => ({
        open: open,
        send: jest.fn(),
        setRequestHeader: jest.fn(),
      });
      window.XMLHttpRequest = jest.fn().mockImplementation(xhrMock);
      clickSearch();
    });

    it('executes the search after 500ms', (done) => {
      const input = document.getElementById('searchbox__input');

      input.value = 'search term';

      setTimeout(() => {
        expect(open).not.toBeCalled();
      }, 250);

      setTimeout(() => {
        expect(open).toBeCalledWith(
          'GET',
          '/search.json?search%5Bsearch%5D=search%20term',
          true
        );
        expect(open.mock.calls.length).toBe(1);
        done();
      }, 750);
    });

    it('only executes the last search (if less than 500ms apart)', (done) => {
      const input = document.getElementById('searchbox__input');

      input.value = 'first term';

      setTimeout(() => {
        input.value = 'last term';
      }, 250);

      setTimeout(() => {
        expect(open).toBeCalledWith(
          'GET',
          '/search.json?search%5Bsearch%5D=last%20term',
          true
        );
        expect(open.mock.calls.length).toBe(1);
        done();
      }, 1000);
    });

    it('executes two searches (if more than 500ms apart)', (done) => {
      const input = document.getElementById('searchbox__input');

      input.value = 'first term';

      setTimeout(() => {
        input.value = 'last term';
      }, 750);

      setTimeout(() => {
        expect(open).toBeCalledWith(
          'GET',
          '/search.json?search%5Bsearch%5D=first%20term',
          true
        );
        expect(open).toBeCalledWith(
          'GET',
          '/search.json?search%5Bsearch%5D=last%20term',
          true
        );
        expect(open.mock.calls.length).toBe(2);
        done();
      }, 1500);
    });

    it("shows 'Searching...' while searching", (done) => {
      const input = document.getElementById('searchbox__input');

      input.value = 'search term';

      setTimeout(() => {
        const noResultsItem = document.querySelector(
          '.autocomplete__option--no-results'
        );
        expect(noResultsItem.innerHTML).toEqual('Searching...');
        done();
      }, 250);
    });
  });
});
