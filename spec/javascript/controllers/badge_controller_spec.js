import { Application } from '@hotwired/stimulus';
import BadgeController from 'badge_controller.js';

describe('BadgeController', () => {
  let xhrMock = null;

  beforeAll(() => registerController());

  const setBody = (content = '') => {
    document.body.innerHTML = `
      <i data-controller="badge" data-badge-path-value="/a/path" data-badge-json-key-value="countKey">${content}</i>
    `;
  }

  const registerController = () => {
    const application = Application.start();
    application.register('badge', BadgeController);
  }

  const mockFetch = (result) => {
    global.fetch = jest.fn(() => {
      return Promise.resolve({
        json: () => (result)
      })
    })
  }

  const mockFetchFailure = () => {
    global.fetch = jest.fn(() => {
      return Promise.reject()
    })
  }

  beforeEach(() => {
    // Clear badge cache.
    global.window.badgeCache = null;
  })

  describe('when supported', () => {
    describe('when the request returns a count', () => {
      beforeEach(() => {
        mockFetch({ countKey: 4 });
        setBody();
      });

      it('requests the count', () => {
        const options = {
          headers: {
            'Accept': 'application/json'
          }
        }

        expect(fetch).toHaveBeenCalledWith('/a/path', options)
      });

      it('displays the count', () => {
        const badge = document.querySelector('i span');
        expect(badge.innerText).toEqual(4);
      });
    })

    describe('when there is a pre-existing count already displayed', () => {
      beforeEach(() => {
        mockFetch({ countKey: 4 });
        setBody('<span>old count</span>');
      });

      it('removes the previous count', () => {
        const badges = document.querySelectorAll('i span');
        expect(badges.length).toEqual(1);
      });
    });

    describe('when there is a cache of the count in available', () => {
      beforeEach(() => {
        global.window.badgeCache = { '/a/path-countKey': 2 }
        // Mocking a failure is the easiest way to test this,
        // otherwise the new value is rendered before we can
        // assert on the state of the DOM.
        mockFetchFailure();
        setBody();
      });

      it('displays the cached count', () => {
        const badge = document.querySelector('i span');
        expect(badge.innerText).toEqual(2);
      });
    });

    describe('when the count is 0', () => {
      beforeEach(() => {
        mockFetch({ countKey: 0 });
        setBody();
      });

      it('does not display anything', () => {
        const badge = document.querySelector('i span');
        expect(badge).toBeNull();
      })
    })

    describe('when the response does not contain the key', () => {
      beforeEach(() => {
        mockFetch({ notCountKey: 4 });
        setBody();
      });

      it('does not display anything', () => {
        const badge = document.querySelector('i span');
        expect(badge).toBeNull();
      })
    });

    describe('when the response does not contain a number', () => {
      beforeEach(() => {
        mockFetch({ countKey: 'four' });
        setBody();
      });

      it('does not display anything', () => {
        const badge = document.querySelector('i span');
        expect(badge).toBeNull();
      })
    });

    describe('when the request fails', () => {
      beforeEach(() => {
        mockFetchFailure();
        setBody();
      });

      it('does not display anything', () => {
        const badge = document.querySelector('i span');
        expect(badge).toBeNull();
      })
    });
  })

  describe('when unsupported', () => {
    beforeEach(() => {
      delete global.fetch;
      setBody();
    })

    it('does not display anything', () => {
      const badge = document.querySelector('i span');
      expect(badge).toBeNull();
    })
  })
});
