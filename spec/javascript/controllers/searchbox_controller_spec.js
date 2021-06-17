import { Application } from 'stimulus' ;
import SearchboxController from 'searchbox_controller.js' ;

describe('SearchboxController', () => {
  const searchboxTemplate = `
    <div data-controller="searchbox" class="searchbox">
      <a href="#" data-action="searchbox#toggle">
        Toggle
      </a>

      <div data-searchbox-target="searchbar">
      </div>
    </div>
  `

  const application = Application.start()
  application.register('searchbox', SearchboxController) ;

  beforeEach(() => document.body.innerHTML = searchboxTemplate)

  describe("initialising autocomplete", () => {
    it("should create autocomplete-wrapper div", () => {
      const autocompletes = document.querySelectorAll('.autocomplete__wrapper')

      expect(autocompletes.length).toBe(1)
    })
  })

  describe("typing in the search box", () => {
    var open

    beforeEach(() => {
      open = jest.fn()
      const xhrMock = () => ({
        open: open,
        send: jest.fn(),
        setRequestHeader: jest.fn()
      })
      window.XMLHttpRequest = jest.fn().mockImplementation(xhrMock)
      document.querySelector('.searchbox a[data-action]').click()
      document.dispatchEvent(new CustomEvent('navigation:menu'))
    })

    it("executes the search after 500ms", (done) => {
      const input = document.getElementById('searchbox__input')

      input.value = 'search term'

      setTimeout(() => {
        expect(open).not.toBeCalled();
      }, 250)

      setTimeout(() => {
        expect(open).toBeCalledWith('GET', '/search.json?search%5Bsearch%5D=search%20term', true);
        expect(open.mock.calls.length).toBe(1);
        done();
      }, 750);
    })

    it("only executes the last search (if less than 500ms apart)", (done) => {
      const input = document.getElementById('searchbox__input')

      input.value = 'first term'

      setTimeout(() => {
        input.value = 'last term'
      }, 250)

      setTimeout(() => {
        expect(open).toBeCalledWith('GET', '/search.json?search%5Bsearch%5D=last%20term', true);
        expect(open.mock.calls.length).toBe(1);
        done();
      }, 1000);
    })

    it("executes two searches (if more than 500ms apart)", (done) => {
      const input = document.getElementById('searchbox__input')

      input.value = 'first term'

      setTimeout(() => {
        input.value = 'last term'
      }, 750)

      setTimeout(() => {
        expect(open).toBeCalledWith('GET', '/search.json?search%5Bsearch%5D=first%20term', true);
        expect(open).toBeCalledWith('GET', '/search.json?search%5Bsearch%5D=last%20term', true);
        expect(open.mock.calls.length).toBe(2);
        done();
      }, 1500);
    })
  })

  describe("toggling search open and close", () => {
    it("should open the searchbar", () => {
      const searchBar = () => {
        return document.querySelectorAll('.searchbox--opened')
      }

      expect(searchBar().length).toBe(0)

      document.querySelector('.searchbox a[data-action]').click()
      expect(searchBar().length).toBe(1)

      document.querySelector('.searchbox a[data-action]').click()
      expect(searchBar().length).toBe(0)
    })
  })

  describe("mobile menu opening", () => {
    describe('when searchbox already open', () => {
      beforeEach(() => {
        document.querySelector('.searchbox a[data-action]').click()
        document.dispatchEvent(new CustomEvent('navigation:menu'))
      })

      it("hides the search box", () => {
        expect(document.querySelectorAll('.searchbox--opened').length).toBe(0)
      })
    })

    describe('when searchbox is hidden', () => {
      beforeEach(() => {
        document.dispatchEvent(new CustomEvent('navigation:menu'))
      })

      it("leaves the search box hidden", () => {
        expect(document.querySelectorAll('.searchbox--opened').length).toBe(0)
      })
    })
  })
})
