import { Controller } from "stimulus"
import accessibleAutocomplete from 'accessible-autocomplete'

export default class extends Controller {
  static inputId = 'searchbox__input'
  static openedClass = 'searchbox--opened'
  static targets = ['searchbar']

  connect() {
    this.setupAccessibleAutocomplete()
  }

  disconnect() {
    if (this.autocompleteWrapper)
      this.autocompleteWrapper.remove()
  }

  toggle(ev) {
    ev.preventDefault()
    this.element.classList.toggle(this.constructor.openedClass)

    if (this.element.classList.contains(this.constructor.openedClass) && this.inputField)
      this.inputField.focus() ;
  }

  get autocompleteWrapper() {
    return this.searchbarTarget.querySelector(".autocomplete__wrapper")
  }

  get inputField() {
    return this.searchbarTarget.querySelector("input")
  }

  setupAccessibleAutocomplete() {
    accessibleAutocomplete({
      element: this.searchbarTarget,
      id: this.constructor.inputId,
      displayMenu: 'overlay',
      minLength: 2,
      source: this.performXhrSearch.bind(this),
      confirmOnBlur: false,
      onConfirm: this.onConfirm,
      templates: {
        inputValue: this.inputValueTemplate.bind(this),
        suggestion: this.formatResults.bind(this)
      }
    })
  }

  performXhrSearch(query, callback) {
    const params = encodeURIComponent("search[search]") + "=" + encodeURIComponent(query) ;

    let request = new XMLHttpRequest()
    request.open('GET', '/search.json?' + params, true)
    request.timeout = 10 * 1000
    request.onreadystatechange = function () {
      if (request.readyState === XMLHttpRequest.DONE && request.status === 200) {
        const results = JSON.parse(request.responseText)
        callback(results)
      }
    }

    request.send()
  }

  onConfirm(chosen) {
    if (chosen && chosen.link)
      Turbolinks.visit(chosen.link)
  }

  inputValueTemplate(result) {
    if (result)
      return result.title
  }

  formatResults(result) {
    if (result)
      return result.html
  }
}
