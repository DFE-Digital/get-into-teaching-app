import { Controller } from "stimulus"
import accessibleAutocomplete from 'accessible-autocomplete'
import Redacter from '../javascript/redacter'

export default class extends Controller {
  static openedClass = 'searchbox--opened'
  static targets = ['searchbar']
  static values = { searchInputId: String }

  searchQuery = null

  connect() {
    this.setupAccessibleAutocomplete()

    this.mobileMenuHandler = this.hide.bind(this)
    document.addEventListener('navigation:menu', this.mobileMenuHandler)
  }

  disconnect() {
    if (this.autocompleteWrapper)
      this.autocompleteWrapper.remove()

    this.clearAnalyticsSubmitter() ;

    if (document && this.mobileMenuHandler)
      document.removeEventListener('navigation:menu', this.mobileMenuHandler)
  }

  toggle(ev) {
    ev.preventDefault()

    this.visible ? this.hide() : this.show()
  }

  get visible() {
    return this.element.classList.contains(this.constructor.openedClass)
  }

  get searchInputId() {
    return 'searchbox__input';
  }

  show() {
    if (this.visible) return

    this.element.classList.add(this.constructor.openedClass)

    if (this.inputField)
      this.inputField.focus()

    this.notify()
  }

  hide() {
    if (!this.visible) return

    this.element.classList.remove(this.constructor.openedClass)
  }

  get autocompleteWrapper() {
    return this.searchbarTarget.querySelector(".autocomplete__wrapper")
  }

  get inputField() {
    return this.searchbarTarget.querySelector("input")
  }

  setupAccessibleAutocomplete() {
    accessibleAutocomplete({
      placeholder: "Search Get Into Teaching",
      element: this.searchbarTarget,
      id: this.searchInputIdValue,
      displayMenu: 'overlay',
      minLength: 2,
      source: this.performXhrSearch.bind(this),
      confirmOnBlur: false,
      tNoResults: () => this.searching ? "Searching..." : "No results found",
      onConfirm: this.onConfirm.bind(this),
      templates: {
        inputValue: this.inputValueTemplate.bind(this),
        suggestion: this.formatResults.bind(this)
      }
    })
  }

  searchParams(query) {
    return encodeURIComponent("search[search]") + "=" + encodeURIComponent(query) ;
  }

  performXhrSearch(query, callback) {
    this.searching = true

    if (this.delaySearchTimeout) {
      clearTimeout(this.delaySearchTimeout);
    }

    this.delaySearchTimeout = setTimeout(() => {
      this.searchQuery = query
      this.scheduleSubmissionToAnalytics()

      let request = new XMLHttpRequest()
      request.open('GET', '/search.json?' + this.searchParams(query), true)
      request.timeout = 10 * 1000
      request.onreadystatechange = () => {
        if (request.readyState === XMLHttpRequest.DONE && request.status === 200) {
          const results = JSON.parse(request.responseText)
          this.searching = false
          callback(results)
        }
      }

      request.send()
    }, 500)
  }

  onConfirm(chosen) {
    if (chosen && chosen.link) {
      if (this.analyticsSubmitter)
        this.sendToAnalytics()

      Turbolinks.visit(chosen.link)
    }
  }

  inputValueTemplate(result) {
    if (result)
      return result.title
  }

  formatResults(result) {
    if (result)
      return result.html
  }

  get redactedQuery() {
    return (new Redacter(this.searchQuery)).redacted
  }

  get google_analytics_id() {
    const ga_id = document.body.getAttribute('data-analytics-ga-id')

    if (ga_id && ga_id.trim() != "")
      return ga_id
  }

  scheduleSubmissionToAnalytics() {
    this.clearAnalyticsSubmitter() ;

    this.analyticsSubmitter = window.setTimeout(this.sendToAnalytics.bind(this), 2000)
  }

  sendToAnalytics() {
    this.clearAnalyticsSubmitter() ;

    if (window.ga && this.google_analytics_id) {
      window.ga('create', this.google_analytics_id, 'auto')
      window.ga('set', 'title', 'Get Into Teaching: Search Get Into Teaching')
      window.ga('set', 'page', '/search?' + this.searchParams(this.redactedQuery))
      window.ga('send', 'pageview')
    }
  }

  clearAnalyticsSubmitter() {
    if (!this.analyticsSubmitter)
      return

    window.clearTimeout(this.analyticsSubmitter)
    this.analyticsSubmitter = null
  }

  notify() {
    const showingSearchEvent = new CustomEvent('navigation:search');

    document.dispatchEvent(showingSearchEvent);
  }
}
