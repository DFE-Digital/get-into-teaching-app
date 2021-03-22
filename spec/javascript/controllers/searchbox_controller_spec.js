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
