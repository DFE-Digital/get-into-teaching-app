import { Application } from 'stimulus' ;
import SearchboxController from 'searchbox_controller.js' ;

describe('SearchboxController', () => {
  document.body.innerHTML = `
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
})
